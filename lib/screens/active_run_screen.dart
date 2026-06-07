import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/geo_sample.dart';
import '../models/location_debug_log.dart';
import '../models/run_session.dart';
import '../models/user_profile.dart';
import '../services/location_tracker.dart';
import '../services/run_storage_service.dart';
import '../services/step_counter_service.dart';
import '../utils/run_formatters.dart';
import '../widgets/bolt_widget.dart';
import '../widgets/metric_tile.dart';

enum RunStatus { ready, running, paused }

enum GpsStatus { checking, ready, permissionNeeded, serviceDisabled, error }

class ActiveRunScreen extends StatefulWidget {
  const ActiveRunScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends State<ActiveRunScreen> {
  final _tracker = LocationTracker();
  final _storage = RunStorageService();
  final _stepCounter = StepCounterService();
  final AudioPlayer? _apitoPlayer = kIsWeb ? null : AudioPlayer();
  final _route = <GeoSample>[];
  final _locationDebugLogs = <LocationDebugLog>[];
  StreamSubscription<LocationUpdate>? _locationSubscription;
  StreamSubscription<int>? _stepSubscription;
  Timer? _timer;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  double _distanceMeters = 0;
  int _steps = 0;
  int _stepsBeforeCurrentSegment = 0;
  RunStatus _status = RunStatus.ready;
  GpsStatus _gpsStatus = GpsStatus.checking;
  String? _message;
  String _gpsMessage = 'Buscando GPS...';
  var _mostrarMascote = false;

  @override
  void initState() {
    super.initState();
    _prepareGps();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationSubscription?.cancel();
    _stepSubscription?.cancel();
    _tracker.stop();
    _stepCounter.stop();
    _apitoPlayer?.dispose();
    super.dispose();
  }

  Future<void> _prepareGps() async {
    setState(() {
      _gpsStatus = GpsStatus.checking;
      _gpsMessage = 'Buscando GPS...';
      _message = 'Vou esperar o GPS ficar pronto antes da corrida.';
    });

    try {
      await _tracker.ensureReady();
      await _tracker.currentSample();
      if (!mounted) return;
      setState(() {
        _gpsStatus = GpsStatus.ready;
        _gpsMessage = 'GPS pronto';
        _message = 'GPS pronto. Toque em Iniciar corrida.';
      });
    } on LocationTrackerException catch (error) {
      if (!mounted) return;
      setState(() {
        _gpsStatus = error.message.toLowerCase().contains('gps')
            ? GpsStatus.serviceDisabled
            : GpsStatus.permissionNeeded;
        _gpsMessage = error.message;
        _message = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _gpsStatus = GpsStatus.error;
        _gpsMessage = 'Nao foi possivel preparar o GPS.';
        _message = 'Falha ao preparar GPS: $error';
      });
    }
  }

  Future<void> _startWithMascote() async {
    await _executarAberturaMascote();
    if (!mounted) return;
    await _start();
  }

  Future<void> _executarAberturaMascote() async {
    setState(() => _mostrarMascote = true);
    await WidgetsBinding.instance.endOfFrame;

    if (_apitoPlayer != null) {
      try {
        unawaited(_apitoPlayer.play(AssetSource('apito.mp3')));
      } catch (e) {
        debugPrint('Erro ao tocar apito: $e');
      }
    }

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() => _mostrarMascote = false);
  }

  Future<void> _start() async {
    if (_gpsStatus != GpsStatus.ready) {
      await _prepareGps();
      if (!mounted || _gpsStatus != GpsStatus.ready) return;
    }

    try {
      await _tracker.ensureReady();
      await _stepCounter.ensureReady();
      _tracker.reset();
      _stepCounter.reset();
      _stepsBeforeCurrentSegment = _steps;
      _startedAt ??= DateTime.now();
      final sample = await _tracker.currentSample();
      if (sample != null) {
        _route.add(sample.copyWith(speedMetersPerSecond: null));
      }

      _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (_status == RunStatus.running) {
          setState(() => _elapsed += const Duration(seconds: 1));
        }
      });

      await _locationSubscription?.cancel();
      await _stepSubscription?.cancel();
      _locationSubscription = _tracker.start().listen(
        (update) {
          setState(() {
            final nextDistance = _distanceMeters + update.deltaMeters;
            if (update.isAccepted) {
              _route.add(update.sample);
            }
            _locationDebugLogs.add(
              LocationDebugLog(
                latitude: update.sample.latitude,
                longitude: update.sample.longitude,
                recordedAt: update.sample.recordedAt,
                accuracy: update.sample.accuracy,
                instantSpeedMetersPerSecond: update.instantSpeedMetersPerSecond,
                deltaMeters: update.deltaMeters,
                accumulatedDistanceMeters: nextDistance,
                accepted: update.isAccepted,
                message: update.statusMessage,
              ),
            );
            if (kDebugMode) {
              debugPrint(
                'GPS debug | lat=${update.sample.latitude}, '
                'lng=${update.sample.longitude}, '
                'time=${update.sample.recordedAt.toIso8601String()}, '
                'accuracy=${update.sample.accuracy.toStringAsFixed(1)}m, '
                'speed=${update.instantSpeedMetersPerSecond.toStringAsFixed(2)}m/s, '
                'delta=${update.deltaMeters.toStringAsFixed(1)}m, '
                'total=${nextDistance.toStringAsFixed(1)}m, '
                'accepted=${update.isAccepted}',
              );
            }
            _distanceMeters = nextDistance;
            _message = update.statusMessage;
            if (update.isAccepted) {
              _gpsStatus = GpsStatus.ready;
              _gpsMessage = 'GPS ativo';
            }
          });
        },
        onError: (error) {
          setState(() => _message = 'Falha no GPS: $error');
        },
      );
      _stepSubscription = _stepCounter.start().listen(
        (steps) {
          setState(() => _steps = _stepsBeforeCurrentSegment + steps);
        },
        onError: (error) {
          setState(() => _message = error.toString());
        },
      );

      setState(() {
        _status = RunStatus.running;
        _message = 'Corrida em andamento.';
        _gpsStatus = GpsStatus.ready;
        _gpsMessage = 'GPS ativo';
      });
    } on LocationTrackerException catch (error) {
      setState(() {
        _gpsStatus = error.message.toLowerCase().contains('gps')
            ? GpsStatus.serviceDisabled
            : GpsStatus.permissionNeeded;
        _gpsMessage = error.message;
        _message = error.message;
      });
    } on StepCounterException catch (error) {
      setState(() => _message = error.message);
    }
  }

  Future<void> _pause() async {
    await _locationSubscription?.cancel();
    await _stepSubscription?.cancel();
    await _tracker.stop();
    await _stepCounter.stop();
    setState(() {
      _status = RunStatus.paused;
      _message = 'Corrida pausada.';
    });
  }

  Future<void> _finish() async {
    if (_startedAt == null || _elapsed.inSeconds == 0) {
      Navigator.of(context).pop();
      return;
    }

    await _locationSubscription?.cancel();
    await _stepSubscription?.cancel();
    await _tracker.stop();
    await _stepCounter.stop();

    final run = RunSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      startedAt: _startedAt!,
      endedAt: DateTime.now(),
      duration: _elapsed,
      distanceMeters: _distanceMeters,
      route: List.unmodifiable(_route),
      steps: _steps,
      bodyWeightKg: widget.profile.bodyWeightKg,
      heightCm: widget.profile.heightCm,
      age: widget.profile.age,
      locationDebugLogs: List.unmodifiable(_locationDebugLogs),
    );

    await _storage.saveRun(run);

    if (!mounted) return;
    Navigator.of(context).pop(run);
  }

  @override
  Widget build(BuildContext context) {
    final previewRun = RunSession(
      id: 'preview',
      startedAt: _startedAt ?? DateTime.now(),
      endedAt: DateTime.now(),
      duration: _elapsed,
      distanceMeters: _distanceMeters,
      route: List.unmodifiable(_route),
      steps: _steps,
      bodyWeightKg: widget.profile.bodyWeightKg,
      heightCm: widget.profile.heightCm,
      age: widget.profile.age,
    );
    final hasReliableDistance = _distanceMeters >= 50;
    final pace = previewRun.paceSecondsPerKm;
    final calories = previewRun.estimatedCalories;

    return Scaffold(
      appBar: AppBar(title: const Text('Corrida ativa')),
      bottomNavigationBar: _mostrarMascote
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: _RunActionPanel(
                  status: _status,
                  gpsStatus: _gpsStatus,
                  gpsMessage: _gpsMessage,
                  onStart: _gpsStatus == GpsStatus.ready
                      ? _startWithMascote
                      : null,
                  onPause: _pause,
                  onResume: _start,
                  onFinish: _finish,
                  onRetryGps: _prepareGps,
                ),
              ),
            ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 260),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDuration(_elapsed),
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _status == RunStatus.running
                              ? 'Mantenha o ritmo'
                              : _status == RunStatus.paused
                              ? 'Pausado'
                              : 'Aguardando inicio',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _RunCoachCard(
                  status: _status,
                  gpsStatus: _gpsStatus,
                  message: _message,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.18,
                  children: [
                    MetricTile(
                      label: 'Distancia',
                      value: formatDistance(_distanceMeters),
                      icon: Icons.route,
                    ),
                    MetricTile(
                      label: 'Pace medio',
                      value: formatPace(pace),
                      icon: Icons.speed,
                    ),
                    MetricTile(
                      label: 'Velocidade',
                      value: !hasReliableDistance || _elapsed.inSeconds == 0
                          ? '--'
                          : formatSpeed(previewRun.averageSpeedKmh),
                      icon: Icons.bolt,
                    ),
                    MetricTile(
                      label: 'Vel. maxima',
                      value: formatSpeed(previewRun.calculatedMaxSpeedKmh),
                      icon: Icons.flash_on,
                    ),
                    MetricTile(
                      label: _steps > 0 ? 'Passos' : 'Passos est.',
                      value: '${previewRun.estimatedSteps}',
                      icon: Icons.directions_walk,
                    ),
                    MetricTile(
                      label: 'Cadencia',
                      value: formatCadence(previewRun.averageCadenceSpm),
                      icon: Icons.repeat,
                    ),
                    MetricTile(
                      label: 'Calorias est.',
                      value: '$calories kcal',
                      icon: Icons.local_fire_department,
                    ),
                    MetricTile(
                      label: 'Altim. est.',
                      value: formatElevationGain(
                        previewRun.calculatedElevationGainMeters,
                      ),
                      icon: Icons.terrain,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_message != null)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.gps_fixed),
                      title: Text(_message!),
                      subtitle: Text(
                        '${_route.length} pontos aceitos | '
                        '${_locationDebugLogs.length} leituras | $_steps passos',
                      ),
                    ),
                  ),
              ],
            ),
            if (_mostrarMascote)
              const Positioned.fill(child: _StartMascotOverlay()),
          ],
        ),
      ),
    );
  }
}

class _RunCoachCard extends StatelessWidget {
  const _RunCoachCard({
    required this.status,
    required this.gpsStatus,
    required this.message,
  });

  final RunStatus status;
  final GpsStatus gpsStatus;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            BoltWidget(expression: _expression, size: 118),
            const SizedBox(height: 12),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message ?? _subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withValues(alpha: 0.68),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoltExpression get _expression {
    return switch (status) {
      RunStatus.running => BoltExpression.fire,
      RunStatus.paused => BoltExpression.ready,
      RunStatus.ready =>
        gpsStatus == GpsStatus.ready
            ? BoltExpression.excited
            : BoltExpression.ready,
    };
  }

  String get _title {
    return switch (status) {
      RunStatus.ready =>
        gpsStatus == GpsStatus.ready
            ? 'Tudo pronto para largar'
            : 'Preparando sua corrida',
      RunStatus.running => 'Estou acompanhando seu treino',
      RunStatus.paused => 'Treino pausado',
    };
  }

  String get _subtitle {
    return switch (status) {
      RunStatus.ready => 'Quando o GPS estiver pronto, use o botao embaixo.',
      RunStatus.running => 'Mantenha o ritmo e acompanhe as metricas.',
      RunStatus.paused => 'Retome ou finalize quando quiser.',
    };
  }
}

class _StartMascotOverlay extends StatelessWidget {
  const _StartMascotOverlay();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 180),
        child: Container(
          color: Colors.black.withValues(alpha: 0.72),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size.width * 0.82,
                height: size.width * 0.82,
                child: Image.asset(
                  'assets/bolt/abertura_mascote.gif',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => const BoltWidget(
                    expression: BoltExpression.excited,
                    size: 180,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Bora treinar!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunActionPanel extends StatelessWidget {
  const _RunActionPanel({
    required this.status,
    required this.gpsStatus,
    required this.gpsMessage,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
    required this.onRetryGps,
  });

  final RunStatus status;
  final GpsStatus gpsStatus;
  final String gpsMessage;
  final VoidCallback? onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;
  final VoidCallback onRetryGps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gpsColor = _gpsColor(theme);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black.withValues(alpha: 0.18),
      color: _panelColor(theme),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: gpsColor.withValues(alpha: 0.14),
                  foregroundColor: gpsColor,
                  child: Icon(_gpsIcon()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _GpsStatusPill(
                        gpsStatus: gpsStatus,
                        gpsMessage: gpsMessage,
                        gpsColor: gpsColor,
                        gpsIcon: _gpsIcon(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (status == RunStatus.ready) ...[
              FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow, size: 26),
                label: const Text('Iniciar corrida'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (gpsStatus != GpsStatus.ready) ...[
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onRetryGps,
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text('Verificar GPS novamente'),
                ),
              ],
            ] else if (status == RunStatus.running) ...[
              FilledButton.icon(
                onPressed: onPause,
                icon: const Icon(Icons.pause),
                label: const Text('Pausar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onFinish,
                icon: const Icon(Icons.stop),
                label: const Text('Finalizar e salvar'),
              ),
            ] else ...[
              FilledButton.icon(
                onPressed: onResume,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Retomar corrida'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onFinish,
                icon: const Icon(Icons.stop),
                label: const Text('Finalizar e salvar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _title {
    return switch (status) {
      RunStatus.ready => 'Pronto para treinar?',
      RunStatus.running => 'Corrida em andamento',
      RunStatus.paused => 'Corrida pausada',
    };
  }

  IconData _gpsIcon() {
    return switch (gpsStatus) {
      GpsStatus.checking => Icons.gps_not_fixed,
      GpsStatus.ready => Icons.gps_fixed,
      GpsStatus.permissionNeeded => Icons.location_disabled,
      GpsStatus.serviceDisabled => Icons.gps_off,
      GpsStatus.error => Icons.error_outline,
    };
  }

  Color _gpsColor(ThemeData theme) {
    return switch (gpsStatus) {
      GpsStatus.checking => Colors.orange.shade700,
      GpsStatus.ready => Colors.green.shade700,
      GpsStatus.permissionNeeded ||
      GpsStatus.serviceDisabled ||
      GpsStatus.error => theme.colorScheme.error,
    };
  }

  Color _panelColor(ThemeData theme) {
    return switch (status) {
      RunStatus.ready => Colors.green.shade50,
      RunStatus.running => theme.colorScheme.primaryContainer,
      RunStatus.paused => Colors.orange.shade50,
    };
  }
}

class _GpsStatusPill extends StatelessWidget {
  const _GpsStatusPill({
    required this.gpsStatus,
    required this.gpsMessage,
    required this.gpsColor,
    required this.gpsIcon,
  });

  final GpsStatus gpsStatus;
  final String gpsMessage;
  final Color gpsColor;
  final IconData gpsIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: gpsColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gpsColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(gpsIcon, color: gpsColor, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: gpsColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    return switch (gpsStatus) {
      GpsStatus.checking => 'Buscando GPS',
      GpsStatus.ready => gpsMessage,
      GpsStatus.permissionNeeded => 'Permissao necessaria',
      GpsStatus.serviceDisabled => 'GPS desligado',
      GpsStatus.error => 'Erro no GPS',
    };
  }
}

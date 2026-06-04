import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/geo_sample.dart';
import '../models/run_session.dart';
import '../models/user_profile.dart';
import '../services/location_tracker.dart';
import '../services/run_storage_service.dart';
import '../services/step_counter_service.dart';
import '../utils/run_formatters.dart';
import '../widgets/metric_tile.dart';

enum RunStatus { ready, running, paused }

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
  final _apitoPlayer = AudioPlayer();
  final _route = <GeoSample>[];
  late final VideoPlayerController _mascoteController;
  StreamSubscription<LocationUpdate>? _locationSubscription;
  StreamSubscription<int>? _stepSubscription;
  Timer? _timer;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  double _distanceMeters = 0;
  int _steps = 0;
  int _stepsBeforeCurrentSegment = 0;
  RunStatus _status = RunStatus.ready;
  String? _message;
  var _mostrarMascote = false;

  @override
  void initState() {
    super.initState();
    _mascoteController = VideoPlayerController.asset(
      'assets/bolt/abertura_mascote.mp4',
    );
    _mascoteController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationSubscription?.cancel();
    _stepSubscription?.cancel();
    _tracker.stop();
    _stepCounter.stop();
    _mascoteController.dispose();
    _apitoPlayer.dispose();
    super.dispose();
  }

  Future<void> _startWithMascote() async {
    await _executarAberturaMascote();
    if (!mounted) return;
    await _start();
  }

  Future<void> _executarAberturaMascote() async {
    if (!_mascoteController.value.isInitialized) return;

    setState(() => _mostrarMascote = true);

    await _mascoteController.seekTo(Duration.zero);
    await _mascoteController.play();
    await _apitoPlayer.play(AssetSource('apito.mp3'));

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    await _mascoteController.pause();
    setState(() => _mostrarMascote = false);
  }

  Future<void> _start() async {
    try {
      await _tracker.ensureReady();
      await _stepCounter.ensureReady();
      _tracker.reset();
      _stepCounter.reset();
      _stepsBeforeCurrentSegment = _steps;
      _startedAt ??= DateTime.now();
      final sample = await _tracker.currentSample();
      if (sample != null) _route.add(sample);

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
            if (update.isAccepted) {
              _route.add(update.sample);
            }
            _distanceMeters += update.deltaMeters;
            _message = update.statusMessage;
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
      });
    } on LocationTrackerException catch (error) {
      setState(() => _message = error.message);
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
      route: const [],
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                        : '${previewRun.averageSpeedKmh.toStringAsFixed(1)} km/h',
                    icon: Icons.bolt,
                  ),
                  MetricTile(
                    label: 'Passos',
                    value: '$_steps',
                    icon: Icons.directions_walk,
                  ),
                  MetricTile(
                    label: 'Calorias',
                    value: '$calories kcal',
                    icon: Icons.local_fire_department,
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
                      '${_route.length} pontos GPS | $_steps passos',
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (_status == RunStatus.ready)
                FilledButton.icon(
                  onPressed: _startWithMascote,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                )
              else if (_status == RunStatus.running)
                FilledButton.icon(
                  onPressed: _pause,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pausar'),
                )
              else
                FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continuar'),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _finish,
                icon: const Icon(Icons.stop),
                label: const Text('Finalizar e salvar'),
              ),
            ],
          ),
          if (_mostrarMascote)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: _mascoteController.value.isInitialized
                        ? VideoPlayer(_mascoteController)
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

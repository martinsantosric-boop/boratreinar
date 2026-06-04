import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../models/geo_sample.dart';

class LocationTracker {
  static const _maxUsableAccuracyMeters = 30.0;
  static const _minMovementMeters = 8.0;
  static const _maxRunnerSpeedMetersPerSecond = 8.5;

  StreamSubscription<Position>? _subscription;
  Position? _lastAcceptedPosition;

  Future<void> ensureReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationTrackerException(
        'Ative o GPS do aparelho para iniciar a corrida.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationTrackerException('Permissao de localizacao negada.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationTrackerException(
        'A permissao de localizacao esta bloqueada nas configuracoes.',
      );
    }
  }

  Future<GeoSample?> currentSample() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    _lastAcceptedPosition = position;
    return _toSample(position);
  }

  Stream<LocationUpdate> start() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );

    final controller = StreamController<LocationUpdate>();
    _subscription = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) {
          final sample = _toSample(position);
          final previous = _lastAcceptedPosition;

          if (position.accuracy > _maxUsableAccuracyMeters) {
            controller.add(
              LocationUpdate(
                sample: sample,
                deltaMeters: 0,
                isAccepted: false,
                statusMessage:
                    'GPS instavel: aguardando precisao melhor para somar km.',
              ),
            );
            return;
          }

          if (previous == null) {
            _lastAcceptedPosition = position;
            controller.add(
              LocationUpdate(
                sample: sample,
                deltaMeters: 0,
                isAccepted: true,
                statusMessage: 'GPS calibrado. Pode iniciar o movimento.',
              ),
            );
            return;
          }

          final deltaMeters = Geolocator.distanceBetween(
            previous.latitude,
            previous.longitude,
            position.latitude,
            position.longitude,
          );
          final seconds =
              position.timestamp
                  .difference(previous.timestamp)
                  .inMilliseconds
                  .abs() /
              1000;
          final speedMetersPerSecond = seconds <= 0 ? 0 : deltaMeters / seconds;
          final requiredMovementMeters = math.max(
            _minMovementMeters,
            math.max(previous.accuracy, position.accuracy) * 0.7,
          );

          if (deltaMeters < requiredMovementMeters) {
            controller.add(
              LocationUpdate(
                sample: sample,
                deltaMeters: 0,
                isAccepted: false,
                statusMessage:
                    'Aguardando movimento real. Pequena variacao do GPS ignorada.',
              ),
            );
            return;
          }

          if (speedMetersPerSecond > _maxRunnerSpeedMetersPerSecond) {
            controller.add(
              LocationUpdate(
                sample: sample,
                deltaMeters: 0,
                isAccepted: false,
                statusMessage: 'Salto de GPS ignorado para manter a precisao.',
              ),
            );
            return;
          }

          _lastAcceptedPosition = position;
          controller.add(
            LocationUpdate(
              sample: sample,
              deltaMeters: deltaMeters,
              isAccepted: true,
              statusMessage:
                  'GPS ativo: ${position.accuracy.toStringAsFixed(0)} m',
            ),
          );
        }, onError: controller.addError);

    controller.onCancel = stop;
    return controller.stream;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void reset() {
    _lastAcceptedPosition = null;
  }

  GeoSample _toSample(Position position) {
    return GeoSample(
      latitude: position.latitude,
      longitude: position.longitude,
      recordedAt: position.timestamp,
      accuracy: position.accuracy,
    );
  }
}

class LocationUpdate {
  const LocationUpdate({
    required this.sample,
    required this.deltaMeters,
    required this.isAccepted,
    required this.statusMessage,
  });

  final GeoSample sample;
  final double deltaMeters;
  final bool isAccepted;
  final String statusMessage;
}

class LocationTrackerException implements Exception {
  const LocationTrackerException(this.message);

  final String message;

  @override
  String toString() => message;
}

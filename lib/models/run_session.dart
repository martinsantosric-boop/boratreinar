import 'geo_sample.dart';
import 'location_debug_log.dart';

class RunSession {
  const RunSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
    required this.distanceMeters,
    required this.route,
    this.steps = 0,
    this.notes,
    this.bodyWeightKg = 70,
    this.heightCm = 170,
    this.age = 30,
    this.maxSpeedKmh,
    this.elevationGainMeters,
    this.averageHeartRateBpm,
    this.locationDebugLogs = const [],
  });

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;
  final double distanceMeters;
  final List<GeoSample> route;
  final int steps;
  final String? notes;
  final double bodyWeightKg;
  final double heightCm;
  final int age;
  final double? maxSpeedKmh;
  final double? elevationGainMeters;
  final int? averageHeartRateBpm;
  final List<LocationDebugLog> locationDebugLogs;

  double get distanceKm => distanceMeters / 1000;

  double get averageSpeedKmh {
    if (duration.inSeconds == 0 || distanceMeters < 50) return 0;
    return distanceKm / (duration.inSeconds / 3600);
  }

  int get paceSecondsPerKm {
    if (distanceMeters < 50 || duration.inMilliseconds == 0) return 0;
    final secondsPerKm = duration.inMilliseconds / 1000 / distanceKm;
    return secondsPerKm.round();
  }

  int get estimatedCalories {
    if (distanceMeters < 50 || duration.inSeconds == 0) return 0;
    final minutes = duration.inSeconds / 60;
    final calories = _metForSpeed(averageSpeedKmh) * 3.5 * bodyWeightKg / 200;
    return (calories * minutes).round();
  }

  double get calculatedMaxSpeedKmh {
    if (maxSpeedKmh != null && maxSpeedKmh! > 0) return maxSpeedKmh!;

    var fastestMetersPerSecond = 0.0;
    for (final sample in route) {
      final speed = sample.speedMetersPerSecond;
      if (speed != null && speed > fastestMetersPerSecond) {
        fastestMetersPerSecond = speed;
      }
    }

    return fastestMetersPerSecond * 3.6;
  }

  double get calculatedElevationGainMeters {
    if (elevationGainMeters != null && elevationGainMeters! > 0) {
      return elevationGainMeters!;
    }

    var gain = 0.0;
    double? previousAltitude;

    for (final sample in route) {
      final altitude = sample.altitudeMeters;
      if (altitude == null) continue;

      if (previousAltitude != null) {
        final delta = altitude - previousAltitude;
        if (delta > 1.5) gain += delta;
      }

      previousAltitude = altitude;
    }

    return gain;
  }

  int get averageCadenceSpm {
    if (duration.inSeconds == 0) return 0;
    return (estimatedSteps / (duration.inSeconds / 60)).round();
  }

  int get estimatedSteps {
    if (steps > 0) return steps;
    final strideLengthMeters = heightCm * 0.00414;
    if (distanceMeters <= 0 || strideLengthMeters <= 0) return 0;
    return (distanceMeters / strideLengthMeters).round();
  }

  int get stepsPerKm {
    if (distanceMeters < 50) return 0;
    return (estimatedSteps / distanceKm).round();
  }

  bool get isGpsTracked {
    return route.isNotEmpty || locationDebugLogs.any((log) => log.accepted);
  }

  bool get isManualEntry => !isGpsTracked;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'distanceMeters': distanceMeters,
      'route': route.map((sample) => sample.toJson()).toList(),
      'steps': steps,
      'notes': notes,
      'bodyWeightKg': bodyWeightKg,
      'heightCm': heightCm,
      'age': age,
      'maxSpeedKmh': maxSpeedKmh,
      'elevationGainMeters': elevationGainMeters,
      'averageHeartRateBpm': averageHeartRateBpm,
      'locationDebugLogs': locationDebugLogs
          .map((log) => log.toJson())
          .toList(),
    };
  }

  factory RunSession.fromJson(Map<String, dynamic> json) {
    return RunSession(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      duration: Duration(seconds: json['durationSeconds'] as int),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      route: ((json['route'] as List<dynamic>?) ?? const [])
          .map((sample) => GeoSample.fromJson(sample as Map<String, dynamic>))
          .toList(),
      steps: ((json['steps'] as num?) ?? 0).toInt(),
      notes: json['notes'] as String?,
      bodyWeightKg: ((json['bodyWeightKg'] as num?) ?? 70).toDouble(),
      heightCm: ((json['heightCm'] as num?) ?? 170).toDouble(),
      age: ((json['age'] as num?) ?? 30).toInt(),
      maxSpeedKmh: (json['maxSpeedKmh'] as num?)?.toDouble(),
      elevationGainMeters: (json['elevationGainMeters'] as num?)?.toDouble(),
      averageHeartRateBpm: (json['averageHeartRateBpm'] as num?)?.toInt(),
      locationDebugLogs:
          ((json['locationDebugLogs'] as List<dynamic>?) ?? const [])
              .map(
                (log) => LocationDebugLog.fromJson(log as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  static double _metForSpeed(double speedKmh) {
    if (speedKmh <= 0) return 0;
    final metersPerMinute = speedKmh * 1000 / 60;
    final vo2 = speedKmh < 6.4
        ? 0.1 * metersPerMinute + 3.5
        : 0.2 * metersPerMinute + 3.5;
    return vo2 / 3.5;
  }
}

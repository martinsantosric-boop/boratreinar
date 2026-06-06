import 'package:cooper_maratonista/models/run_session.dart';
import 'package:cooper_maratonista/models/geo_sample.dart';
import 'package:cooper_maratonista/models/location_debug_log.dart';
import 'package:cooper_maratonista/models/user_profile.dart';
import 'package:cooper_maratonista/services/gamification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RunSession buildRun({
    required Duration duration,
    required double distanceMeters,
    double bodyWeightKg = 70,
    double heightCm = 170,
    int steps = 0,
  }) {
    final endedAt = DateTime(2026, 5, 30, 8);
    return RunSession(
      id: 'run-id',
      startedAt: endedAt.subtract(duration),
      endedAt: endedAt,
      duration: duration,
      distanceMeters: distanceMeters,
      route: const [],
      bodyWeightKg: bodyWeightKg,
      heightCm: heightCm,
      steps: steps,
    );
  }

  test('pace keeps minute and second conversion precise', () {
    final run = buildRun(
      duration: const Duration(minutes: 26, seconds: 40),
      distanceMeters: 5000,
    );

    expect(run.paceSecondsPerKm, 320);
  });

  test('estimated calories respond to user weight and running intensity', () {
    final easyRun = buildRun(
      duration: const Duration(minutes: 36),
      distanceMeters: 5000,
      bodyWeightKg: 60,
    );
    final fasterHeavierRun = buildRun(
      duration: const Duration(minutes: 24),
      distanceMeters: 5000,
      bodyWeightKg: 80,
    );

    expect(
      fasterHeavierRun.estimatedCalories,
      greaterThan(easyRun.estimatedCalories),
    );
  });

  test('profile estimates steps per kilometer from height', () {
    const profile = UserProfile(bodyWeightKg: 72, heightCm: 180, age: 35);

    expect(profile.stepsPerKm, 1342);
  });

  test('run falls back to estimated steps when no sensor data is saved', () {
    final run = buildRun(
      duration: const Duration(minutes: 30),
      distanceMeters: 3000,
      heightCm: 180,
    );

    expect(run.estimatedSteps, 4026);
    expect(run.stepsPerKm, 1342);
  });

  test('run calculates cadence from estimated steps and duration', () {
    final run = buildRun(
      duration: const Duration(minutes: 30),
      distanceMeters: 3000,
      heightCm: 180,
    );

    expect(run.averageCadenceSpm, 134);
  });

  test('run reads max speed and elevation from GPS samples', () {
    final startedAt = DateTime(2026, 5, 30, 8);
    final run = RunSession(
      id: 'gps-run',
      startedAt: startedAt,
      endedAt: startedAt.add(const Duration(minutes: 10)),
      duration: const Duration(minutes: 10),
      distanceMeters: 1000,
      route: [
        GeoSample(
          latitude: -23.0,
          longitude: -46.0,
          recordedAt: startedAt,
          accuracy: 8,
          altitudeMeters: 700,
          speedMetersPerSecond: 2,
        ),
        GeoSample(
          latitude: -23.001,
          longitude: -46.001,
          recordedAt: startedAt.add(const Duration(minutes: 5)),
          accuracy: 8,
          altitudeMeters: 704,
          speedMetersPerSecond: 3.5,
        ),
        GeoSample(
          latitude: -23.002,
          longitude: -46.002,
          recordedAt: startedAt.add(const Duration(minutes: 10)),
          accuracy: 8,
          altitudeMeters: 703,
          speedMetersPerSecond: 2.4,
        ),
      ],
    );

    expect(run.calculatedMaxSpeedKmh, 12.6);
    expect(run.calculatedElevationGainMeters, 4);
  });

  test('run persists optional advanced metrics', () {
    final run = buildRun(
      duration: const Duration(minutes: 40),
      distanceMeters: 7000,
    );
    final json = RunSession(
      id: run.id,
      startedAt: run.startedAt,
      endedAt: run.endedAt,
      duration: run.duration,
      distanceMeters: run.distanceMeters,
      route: run.route,
      maxSpeedKmh: 13.8,
      elevationGainMeters: 45,
      averageHeartRateBpm: 148,
    ).toJson();

    final restored = RunSession.fromJson(json);

    expect(restored.calculatedMaxSpeedKmh, 13.8);
    expect(restored.calculatedElevationGainMeters, 45);
    expect(restored.averageHeartRateBpm, 148);
  });

  test('run persists GPS debug logs for metric auditing', () {
    final endedAt = DateTime(2026, 5, 30, 8);
    final run = RunSession(
      id: 'debug-run',
      startedAt: endedAt.subtract(const Duration(minutes: 10)),
      endedAt: endedAt,
      duration: const Duration(minutes: 10),
      distanceMeters: 1000,
      route: const [],
      locationDebugLogs: [
        LocationDebugLog(
          latitude: -23.0,
          longitude: -46.0,
          recordedAt: endedAt,
          accuracy: 7,
          instantSpeedMetersPerSecond: 2.8,
          deltaMeters: 12,
          accumulatedDistanceMeters: 540,
          accepted: true,
          message: 'GPS ativo: 7 m',
        ),
      ],
    );

    final restored = RunSession.fromJson(run.toJson());

    expect(restored.locationDebugLogs, hasLength(1));
    expect(restored.locationDebugLogs.first.deltaMeters, 12);
    expect(restored.locationDebugLogs.first.accumulatedDistanceMeters, 540);
    expect(restored.locationDebugLogs.first.accepted, isTrue);
  });

  test('run shorter than 30 minutes does not earn xp', () {
    final gamification = GamificationService();
    final run = buildRun(
      duration: const Duration(minutes: 29, seconds: 59),
      distanceMeters: 5000,
    );

    expect(gamification.isEligibleForRewards(run), isFalse);
    expect(gamification.calculateRunXp(run), 0);
  });

  test('run with at least 30 minutes earns xp', () {
    final gamification = GamificationService();
    final run = buildRun(
      duration: const Duration(minutes: 30),
      distanceMeters: 5000,
    );

    expect(gamification.isEligibleForRewards(run), isTrue);
    expect(gamification.calculateRunXp(run), greaterThan(0));
  });
}

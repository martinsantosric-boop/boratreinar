import 'package:cooper_maratonista/models/run_session.dart';
import 'package:cooper_maratonista/models/user_profile.dart';
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
}

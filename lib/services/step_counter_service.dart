import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounterService {
  StreamSubscription<StepCount>? _subscription;
  int? _baselineSteps;

  Future<void> ensureReady() async {
    if (kIsWeb) return;

    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      throw const StepCounterException('Permissao de atividade fisica negada.');
    }
  }

  Stream<int> start() {
    final controller = StreamController<int>();

    if (kIsWeb) {
      controller.onListen = () => controller.add(0);
      return controller.stream;
    }

    _subscription = Pedometer.stepCountStream.listen(
      (event) {
        _baselineSteps ??= event.steps;
        final steps = event.steps - _baselineSteps!;
        controller.add(steps < 0 ? 0 : steps);
      },
      onError: (error) {
        controller.addError(
          StepCounterException('Falha no contador de passos: $error'),
        );
      },
      cancelOnError: false,
    );

    controller.onCancel = stop;
    return controller.stream;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void reset() {
    _baselineSteps = null;
  }
}

class StepCounterException implements Exception {
  const StepCounterException(this.message);

  final String message;

  @override
  String toString() => message;
}

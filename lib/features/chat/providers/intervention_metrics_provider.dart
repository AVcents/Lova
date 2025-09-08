// lib/features/chat_couple/providers/intervention_metrics_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterventionMetrics {
  void logBannerShown(String type) {
    print('[Metrics] Banner shown: $type at ${DateTime.now()}');
  }

  void logDismiss(String type) {
    print('[Metrics] Banner dismissed: $type at ${DateTime.now()}');
  }

  void logRephrase() {
    print('[Metrics] Rephrase action triggered at ${DateTime.now()}');
  }

  void logPause() {
    print('[Metrics] Pause action triggered at ${DateTime.now()}');
  }

  void logSos() {
    print('[Metrics] SOS action triggered at ${DateTime.now()}');
  }

  void logBreathCompleted(int duration) {
    print(
      '[Metrics] Breath exercise completed: ${duration}s at ${DateTime.now()}',
    );
  }

  void logMediationCompleted(int stepsCompleted) {
    print(
      '[Metrics] Mediation completed: $stepsCompleted steps at ${DateTime.now()}',
    );
  }
}

final interventionMetricsProvider = Provider<InterventionMetrics>((ref) {
  return InterventionMetrics();
});

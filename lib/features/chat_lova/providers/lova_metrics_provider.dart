// lib/features/chat_lova/providers/lova_metrics_provider.dart

import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LovaMetrics {
  final int openedCount;
  final int generatedCount;
  final int insertedCount;

  const LovaMetrics({
    this.openedCount = 0,
    this.generatedCount = 0,
    this.insertedCount = 0,
  });

  LovaMetrics copyWith({
    int? openedCount,
    int? generatedCount,
    int? insertedCount,
  }) {
    return LovaMetrics(
      openedCount: openedCount ?? this.openedCount,
      generatedCount: generatedCount ?? this.generatedCount,
      insertedCount: insertedCount ?? this.insertedCount,
    );
  }
}

class LovaMetricsNotifier extends StateNotifier<LovaMetrics> {
  LovaMetricsNotifier() : super(const LovaMetrics());

  void logOpened() {
    developer.log('Composer Assistant opened', name: 'LovaMetrics');
    state = state.copyWith(openedCount: state.openedCount + 1);

    _logEvent('composer_assist_opened', {
      'timestamp': DateTime.now().toIso8601String(),
      'total_opens': state.openedCount,
    });
  }

  void logGenerated(int count) {
    developer.log('Variations generated: $count', name: 'LovaMetrics');
    state = state.copyWith(generatedCount: state.generatedCount + 1);

    _logEvent('composer_assist_generated', {
      'timestamp': DateTime.now().toIso8601String(),
      'variations_count': count,
      'total_generations': state.generatedCount,
    });
  }

  void logInserted() {
    developer.log('Variation inserted into composer', name: 'LovaMetrics');
    state = state.copyWith(insertedCount: state.insertedCount + 1);

    _logEvent('composer_assist_inserted', {
      'timestamp': DateTime.now().toIso8601String(),
      'total_insertions': state.insertedCount,
    });
  }

  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    developer.log('Analytics Event: $eventName', name: 'LovaMetrics');
    developer.log('Parameters: $parameters', name: 'LovaMetrics');
  }

  Map<String, int> getStats() {
    return {
      'opens': state.openedCount,
      'generations': state.generatedCount,
      'insertions': state.insertedCount,
    };
  }

  double get conversionRate {
    if (state.openedCount == 0) return 0.0;
    return (state.insertedCount / state.openedCount) * 100;
  }

  double get usageAfterGenerationRate {
    if (state.generatedCount == 0) return 0.0;
    return (state.insertedCount / state.generatedCount) * 100;
  }
}

final lovaMetricsProvider =
    StateNotifierProvider<LovaMetricsNotifier, LovaMetrics>((ref) {
      return LovaMetricsNotifier();
    });

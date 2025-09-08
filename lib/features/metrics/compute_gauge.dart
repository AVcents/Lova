// lib/features/metrics/compute_gauge.dart

import 'package:lova/features/metrics/metrics.dart';

int computeGaugeScore(ConversationMetrics metrics) {
  // Score sentiment : 0 → 0, 1 → 100
  final sentimentScore = (metrics.sentimentRatio * 100).clamp(0, 100);

  // Temps de réponse : 0–60 sec idéal → 100, au-delà → pénalisé
  final responseScore = metrics.averageResponseTimeSeconds <= 60
      ? 100
      : (100 - (metrics.averageResponseTimeSeconds - 60)).clamp(0, 100);

  // Nombre de messages : idéal à partir de 10 messages
  final messageScore = (metrics.totalMessages * 10).clamp(0, 100);

  // Pondération (0.4 sentiment, 0.3 temps réponse, 0.3 messages)
  final gaugeScore =
      (sentimentScore * 0.4) + (responseScore * 0.3) + (messageScore * 0.3);

  return gaugeScore.round().clamp(0, 100);
}

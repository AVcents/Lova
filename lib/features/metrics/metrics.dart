// lib/features/metrics/metrics.dart

class ConversationMetrics {
  final int totalMessages;
  final double averageResponseTimeSeconds;
  final int positiveWordCount;
  final int negativeWordCount;

  ConversationMetrics({
    required this.totalMessages,
    required this.averageResponseTimeSeconds,
    required this.positiveWordCount,
    required this.negativeWordCount,
  });

  double get sentimentRatio {
    final total = positiveWordCount + negativeWordCount;
    if (total == 0) return 0.5;
    return positiveWordCount / total;
  }

  @override
  String toString() {
    return 'ConversationMetrics(totalMessages: $totalMessages, '
        'avgResponseTime: $averageResponseTimeSeconds s, '
        'positive: $positiveWordCount, negative: $negativeWordCount)';
  }
}
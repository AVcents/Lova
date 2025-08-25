import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'compute_gauge.dart';
import 'metrics.dart';
import '../chat/models/message_model.dart';

final gaugeProvider = Provider<int>((ref) {
  // TODO: remplacer par une vraie source de messages
  final messages = ref.watch(mockMessagesProvider);

  final metrics = computeMetrics(messages);
  final gaugeScore = computeGaugeScore(metrics);

  return gaugeScore;
});

ConversationMetrics computeMetrics(List<MessageModel> messages) {
  if (messages.isEmpty) {
    return ConversationMetrics(
      totalMessages: 0,
      averageResponseTimeSeconds: 0,
      positiveWordCount: 0,
      negativeWordCount: 0,
    );
  }

  int totalPositive = 0;
  int totalNegative = 0;
  int totalResponseTime = 0;
  int responseCount = 0;

  for (int i = 1; i < messages.length; i++) {
    final prev = messages[i - 1];
    final curr = messages[i];
    if (prev.senderId != curr.senderId) {
      final delta = curr.timestamp.difference(prev.timestamp).inSeconds;
      totalResponseTime += delta;
      responseCount++;
    }
  }

  for (final msg in messages) {
    final text = msg.content.toLowerCase();
    totalPositive += _countPositiveWords(text);
    totalNegative += _countNegativeWords(text);
  }

  return ConversationMetrics(
    totalMessages: messages.length,
    averageResponseTimeSeconds:
    responseCount == 0 ? 0 : totalResponseTime / responseCount,
    positiveWordCount: totalPositive,
    negativeWordCount: totalNegative,
  );
}

int _countPositiveWords(String text) {
  const positiveWords = ['merci', 'bien', 'cool', 'génial', 'super', 'ok', 'top', 'bravo'];
  return positiveWords.where((w) => text.contains(w)).length;
}

int _countNegativeWords(String text) {
  const negativeWords = ['fatigué', 'marre', 'nul', 'déteste', 'problème', 'fâché', 'non'];
  return negativeWords.where((w) => text.contains(w)).length;
}

// MOCK
final mockMessagesProvider = Provider<List<MessageModel>>((ref) {
  return [
    MessageModel(
      id: 1,
      senderId: 'A',
      receiverId: 'B',
      content: 'J’en ai marre, tu ne fais aucun effort.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isEncrypted: false,
    ),
    MessageModel(
      id: 2,
      senderId: 'B',
      receiverId: 'A',
      content: 'C’est toujours pareil avec toi.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      isEncrypted: false,
    ),
    MessageModel(
      id: 3,
      senderId: 'A',
      receiverId: 'B',
      content: 'Tu ne comprends jamais rien.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      isEncrypted: false,
    ),
    MessageModel(
      id: 4,
      senderId: 'B',
      receiverId: 'A',
      content: 'Je suis fatigué de répéter les mêmes choses.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      isEncrypted: false,
    ),
    MessageModel(
      id: 5,
      senderId: 'A',
      receiverId: 'B',
      content: 'Tu me déçois tellement.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      isEncrypted: false,
    ),
  ];
});
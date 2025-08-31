// lib/features/chat_lova/providers/lova_chat_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';
import 'package:lova/features/chat_lova/data/real_lova_repository.dart';
import 'package:lova/features/chat_lova/providers/lova_repository_provider.dart';
import 'package:lova/features/chat_lova/data/lova_repository.dart';

/// Liste des messages du chat (état principal)
final lovaMessagesProvider =
StateNotifierProvider<LovaMessagesNotifier, List<LovaMessage>>((ref) {
  final repository = ref.watch(lovaRepositoryProvider);
  return LovaMessagesNotifier(repository);
});

class LovaMessagesNotifier extends StateNotifier<List<LovaMessage>> {
  final LovaRepository repository;

  LovaMessagesNotifier(this.repository) : super([]);

  void sendMessage(String content) {
    final userMessage = LovaMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];

    final stream = repository.getResponse(content, state);

    stream.listen((lovaMessage) {
      state = [...state, lovaMessage];
    });
  }
}
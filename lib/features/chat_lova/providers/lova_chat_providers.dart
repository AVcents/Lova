// lib/features/chat_lova/providers/lova_chat_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/chat_lova/data/lova_repository.dart';
import 'package:lova/features/chat_lova/data/repositories/conversation_repository.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';
import 'package:lova/features/chat_lova/providers/lova_repository_provider.dart';

// Provider du repository de conversations
final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository(Supabase.instance.client);
});

// Provider de l'ID utilisateur
final userIdProvider = Provider<String>((ref) {
  return Supabase.instance.client.auth.currentUser!.id;
});

// Charger l'historique au démarrage
final conversationHistoryProvider =
    FutureProvider<List<LovaMessage>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final repo = ref.watch(conversationRepositoryProvider);
  return repo.getMessages(userId);
});

/// Liste des messages du chat (état principal)
final lovaMessagesProvider =
    StateNotifierProvider<LovaMessagesNotifier, List<LovaMessage>>((ref) {
  final repository = ref.watch(lovaRepositoryProvider);
  final conversationRepo = ref.watch(conversationRepositoryProvider);
  final userId = ref.watch(userIdProvider);

  // Charger historique
  final historyAsync = ref.watch(conversationHistoryProvider);
  final initialMessages = historyAsync.maybeWhen(
    data: (msgs) => msgs,
    orElse: () => <LovaMessage>[],
  );

  return LovaMessagesNotifier(
    repository: repository,
    conversationRepo: conversationRepo,
    userId: userId,
    initialMessages: initialMessages,
  );
});

class LovaMessagesNotifier extends StateNotifier<List<LovaMessage>> {
  final LovaRepository repository;
  final ConversationRepository conversationRepo;
  final String userId;

  LovaMessagesNotifier({
    required this.repository,
    required this.conversationRepo,
    required this.userId,
    List<LovaMessage> initialMessages = const [],
  }) : super(initialMessages);

  void sendMessage(String content) {
    final userMessage = LovaMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];

    // Sauvegarder le message utilisateur
    conversationRepo.saveMessage(userId, userMessage);

    final stream = repository.getResponse(content, state);

    stream.listen((lovaMessage) {
      state = [...state, lovaMessage];
      // Sauvegarder la réponse LOVA
      conversationRepo.saveMessage(userId, lovaMessage);
    });
  }

  Future<void> clearHistory() async {
    await conversationRepo.clearHistory(userId);
    state = [];
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/chat/database/drift_database.dart';
import 'package:lova/features/chat/repository/chat_couple_repository.dart';

// 🔹 StateNotifier pour gérer la liste de messages
class ChatCoupleController extends StateNotifier<List<Message>> {
  final ChatCoupleRepository repository;

  ChatCoupleController(this.repository) : super([]) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await repository.fetchMessages();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    state = messages;
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    await repository.sendMessage(
      senderId: senderId,
      receiverId: receiverId,
      content: content,
    );
    await _loadMessages();
  }
}

// 🔹 Provider de base de données
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// 🔹 Provider du repository
final chatCoupleRepositoryProvider = Provider<ChatCoupleRepository>(
  (ref) => ChatCoupleRepository(ref.watch(databaseProvider)),
);

// 🔹 Provider du controller
final chatCoupleControllerProvider =
    StateNotifierProvider<ChatCoupleController, List<Message>>(
      (ref) => ChatCoupleController(ref.watch(chatCoupleRepositoryProvider)),
    );

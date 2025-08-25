import 'package:lova/features/chat/database/drift_database.dart';
import 'package:drift/drift.dart';
import 'package:lova/features/chat/repository/encryption_helper.dart';

class ChatCoupleRepository {
  final AppDatabase _db;

  ChatCoupleRepository(this._db);

  // 🔹 Ajouter un message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    bool isEncrypted = true,
  }) async {
    final encrypted = await EncryptionHelper.encrypt(content);
    final message = MessagesCompanion(
      senderId: Value(senderId),
      receiverId: Value(receiverId),
      content: Value(encrypted),
      timestamp: Value(DateTime.now()),
      isEncrypted: Value(isEncrypted),
    );

    await _db.insertMessage(message);
  }

  // 🔹 Récupérer tous les messages
  Future<List<Message>> fetchMessages() async {
    final rawMessages = await _db.getAllMessages();

    final decrypted = await Future.wait(rawMessages.map((m) async {
      if (m.isEncrypted) {
        final clear = await EncryptionHelper.decrypt(m.content);
        return Message(
          id: m.id,
          senderId: m.senderId,
          receiverId: m.receiverId,
          content: clear,
          timestamp: m.timestamp,
          isEncrypted: false,
        );
      } else {
        return m;
      }
    }));

    return decrypted;
  }

  // 🔹 Supprimer tous les messages
  Future<void> clearMessages() async {
    await _db.clearMessages();
  }
}
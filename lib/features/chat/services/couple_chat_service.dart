import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/encryption_helper.dart';

class CoupleChatService {
  final SupabaseClient _supabase;

  CoupleChatService(this._supabase);

  /// Envoyer message
  Future<void> sendMessage({
    required String relationId,
    required String senderId,
    required String content,
  }) async {
    // 1. Crypter le contenu
    final contentToStore = await EncryptionHelper.encrypt(content);

    // 2. Insert
    try {
      await _supabase.from('couple_messages').insert({
        'relation_id': relationId,
        'sender_id': senderId,
        'content': contentToStore,
        'message_type': 'normal',
        'is_encrypted': true,
      });
    } catch (e) {
      if (e.toString().contains('Not your turn')) {
        throw Exception('C\'est le tour de ton partenaire');
      }
      rethrow;
    }
  }
}

// Provider
final coupleChatServiceProvider = Provider<CoupleChatService>((ref) {
  return CoupleChatService(Supabase.instance.client);
});

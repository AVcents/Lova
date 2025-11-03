import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/encryption_helper.dart';

class CoupleChatService {
  final SupabaseClient _supabase;

  CoupleChatService(this._supabase);

  /// Envoyer message (normal ou SOS)
  Future<void> sendMessage({
    required String relationId,
    required String senderId,
    required String content,
    String? sosSessionId,
  }) async {
    // 1. Déterminer type
    final messageType = sosSessionId != null ? 'sos_user' : 'normal';

    // 2. Crypter si message normal
    final shouldEncrypt = messageType == 'normal';
    final contentToStore = shouldEncrypt
        ? await EncryptionHelper.encrypt(content)
        : content; // SOS reste en clair pour analytics

    // 3. Insert (trigger vérifiera speaker si SOS)
    try {
      await _supabase.from('couple_messages').insert({
        'relation_id': relationId,
        'sender_id': senderId,
        'content': contentToStore,
        'message_type': messageType,
        'sos_session_id': sosSessionId,
        'is_encrypted': shouldEncrypt,
      });
    } catch (e) {
      if (e.toString().contains('Not your turn')) {
        throw Exception('C\'est le tour de ton partenaire');
      }
      rethrow;
    }
  }

  /// Envoyer message AI (depuis Edge Function)
  Future<void> sendAiMessage({
    required String relationId,
    required String content,
    required String sosSessionId,
  }) async {
    await _supabase.from('couple_messages').insert({
      'relation_id': relationId,
      'sender_id': null, // AI
      'content': content,
      'message_type': 'sos_ai',
      'sos_session_id': sosSessionId,
      'is_encrypted': false, // AI messages en clair
    });
  }
}

// Provider
final coupleChatServiceProvider = Provider<CoupleChatService>((ref) {
  return CoupleChatService(Supabase.instance.client);
});

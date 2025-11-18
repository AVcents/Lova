// lib/features/chat_lova/data/repositories/conversation_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/chat_lova/models/lova_conversation.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

class ConversationRepository {
  final SupabaseClient _supabase;

  ConversationRepository(this._supabase);

  /// Récupère la conversation de l'utilisateur
  Future<List<LovaMessage>> getMessages(String userId) async {
    final response = await _supabase
        .from('lova_conversations')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return [];

    final conversation = LovaConversation.fromJson(response);
    return conversation.messages;
  }

  /// Sauvegarde un nouveau message
  Future<void> saveMessage(String userId, LovaMessage message) async {
    // Récupère conversation existante
    final existing = await _supabase
        .from('lova_conversations')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      // Créer nouvelle conversation
      await _supabase.from('lova_conversations').insert({
        'user_id': userId,
        'messages': [message.toMap()],
      });
    } else {
      // Ajouter message (max 100)
      final conversation = LovaConversation.fromJson(existing);
      final updatedMessages = [...conversation.messages, message];

      // Garder 100 derniers
      final limitedMessages = updatedMessages.length > 100
          ? updatedMessages.sublist(updatedMessages.length - 100)
          : updatedMessages;

      await _supabase.from('lova_conversations').update({
        'messages': limitedMessages.map((m) => m.toMap()).toList(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);
    }
  }

  /// Efface l'historique
  Future<void> clearHistory(String userId) async {
    await _supabase
        .from('lova_conversations')
        .delete()
        .eq('user_id', userId);
  }
}

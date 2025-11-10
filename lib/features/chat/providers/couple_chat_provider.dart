import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/couple_message.dart';
import '../repository/encryption_helper.dart';

// Stream messages d'une relation
final coupleChatProvider = StreamProvider.family.autoDispose<List<CoupleMessage>, String>((ref, relationId) {
  final sb = Supabase.instance.client;

  return sb
      .from('couple_messages')
      .stream(primaryKey: ['id'])
      .eq('relation_id', relationId)
      .order('created_at')
      .asyncMap((data) async {
        // Décrypter messages cryptés
        final messages = <CoupleMessage>[];

        for (var json in data) {
          var msg = CoupleMessage.fromJson(json);

          // Décrypter si nécessaire
          if (msg.isEncrypted && msg.content.isNotEmpty) {
            try {
              final decrypted = await EncryptionHelper.decrypt(msg.content);
              msg = msg.copyWith(content: decrypted, isEncrypted: false);
            } catch (e) {
              print('Decryption error: $e');
            }
          }

          messages.add(msg);
        }

        return messages;
      });
});

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/relation/dashboard/models/couple_checkin.dart';
import 'package:lova/features/relation/dashboard/models/emotion_type.dart';

class CoupleCheckinService {
  final SupabaseClient _sb;
  CoupleCheckinService(this._sb);

  /// Créé un check-in, puis déclenche la classification de ton si du texte existe.
  /// Retourne le check-in (mis à jour avec tone_detected/ai_tokens_used si dispo).
  Future<CoupleCheckin> createCheckin(CoupleCheckin draft) async {
    // 0) Optionnel: quota journalier via Edge Function
    await _checkDailyQuotaOrThrow(userId: draft.userId, relationId: draft.relationId);

    // 1) INSERT
    final insertPayload = _toDb(draft);
    final insertResp = await _sb
        .from('couple_checkins')
        .insert(insertPayload)
        .select()
        .single();

    var created = CoupleCheckin.fromJson(insertResp);

    // 2) Classifier le ton s’il y a au moins un champ texte
    final hasText = (created.gratitudeText?.trim().isNotEmpty == true) ||
        (created.concernText?.trim().isNotEmpty == true) ||
        (created.needText?.trim().isNotEmpty == true);

    if (hasText) {
      try {
        print('🔵 Appel classifier-tone...');
        final cls = await _classifyTone(
          relationId: created.relationId,
          userId: created.userId,
          checkinId: created.id,
          texts: [
            if ((created.gratitudeText ?? '').trim().isNotEmpty)
              {'type': 'gratitude', 'text': created.gratitudeText},
            if ((created.concernText ?? '').trim().isNotEmpty)
              {'type': 'concern', 'text': created.concernText},
            if ((created.needText ?? '').trim().isNotEmpty)
              {'type': 'need', 'text': created.needText},
          ],
        );

        print('✅ Tone détecté: ${cls.tone}, tokens: ${cls.tokensUsed}');

        // 3) Mettre à jour la ligne avec le résultat IA
        final updateResp = await _sb
            .from('couple_checkins')
            .update({
          'tone_detected': cls.tone,
          'ai_tokens_used': cls.tokensUsed,
        })
            .eq('id', created.id)
            .select()
            .single();

        created = CoupleCheckin.fromJson(updateResp);
        print('✅ Check-in mis à jour avec tone');
      } catch (e) {
        print('❌ Erreur classifier-tone: $e'); // ← AJOUTÉ
        // Ne bloque pas le flux si la classification échoue.
      }
    }

    return created;
  }

  // ---------------------------
  // Helpers
  // ---------------------------

  Map<String, dynamic> _toDb(CoupleCheckin c) {
    // Utilise toJson du modèle si déjà mappé snake_case.
    final json = c.toJson();

    // Sécuriser formats de date en ISO (Supabase gère, mais on force proprement).
    json['created_at'] = (c.createdAt).toIso8601String();
    json['checkin_date'] = (c.checkinDate).toIso8601String();

    // Emotion est gérée par toJson() via _emotionToJson => ok
    return json
      ..remove('id'); // id généré côté DB si besoin (si déjà présent, laisse)
  }

  Future<_ToneResult> _classifyTone({
    required String relationId,
    required String userId,
    required String checkinId,
    required List<Map<String, dynamic>> texts,
  }) async {
    // Concaténer tous les textes en un seul
    final allTexts = texts.map((t) => t['text'] as String).join(' ');

    final resp = await _sb.functions.invoke(
      'classifier-tone',
      body: {
        'relation_id': relationId,
        'user_id': userId,
        'checkin_id': checkinId,
        'text': allTexts, // ← UN SEUL champ "text"
      },
    );

    final data = resp.data is Map ? resp.data as Map : <String, dynamic>{};
    final tone = (data['tone'] ?? 'neutral').toString();
    final tokens = (data['tokens_used'] ?? 0) as int;

    return _ToneResult(tone: tone, tokensUsed: tokens);
  }

  bool _looksLikeUuid(String input) {
    // Simple UUID v1/v4 pattern check
    final reg = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    return reg.hasMatch(input);
  }

  Future<void> _checkDailyQuotaOrThrow({
    required String userId,
    required String relationId,
  }) async {
    // Skip in dev if relationId placeholder is not a UUID to avoid 500 from Edge Function
    if (!_looksLikeUuid(relationId)) {
      // print('[quota] skipped: invalid relationId format: $relationId');
      return;
    }

    try {
      final resp = await _sb.functions.invoke(
        'check-daily-quota',
        body: {
          'resource': 'couple_checkins',
          'user_id': userId,
          'relation_id': relationId,
        },
      );

      final dynamic dyn = resp;
      final int? status = (dyn is Object && (dyn as dynamic).status != null)
          ? (dyn as dynamic).status as int
          : null;

      if (status != null && status >= 400) {
        throw Exception('Quota quotidien atteint ou payload invalide');
      }
    } catch (_) {
      // Do not block check-in creation on quota check failure during development.
    }
  }
}

class _ToneResult {
  final String tone;
  final int tokensUsed;
  _ToneResult({required this.tone, required this.tokensUsed});
}
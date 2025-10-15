import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/us_dashboard/models/couple_checkin.dart';
import 'package:lova/features/us_dashboard/models/emotion_type.dart';
import 'package:lova/features/us_dashboard/services/couple_checkin_service.dart';
import 'package:uuid/uuid.dart'; // Ajoute en haut

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final coupleCheckinServiceProvider = Provider<CoupleCheckinService>((ref) {
  final sb = ref.watch(supabaseClientProvider);
  return CoupleCheckinService(sb);
});

final todayCoupleCheckinProvider = FutureProvider.autoDispose<CoupleCheckin?>((ref) async {
  // Supabase client
  final sb = ref.watch(supabaseClientProvider);

  // Auth guard
  final userId = sb.auth.currentUser?.id;
  if (userId == null) return null;

  // Compute today as YYYY-MM-DD (matches DB `checkin_date`)
  final today = DateTime.now().toIso8601String().split('T')[0];

  // Query today's check-in for the current user
  final data = await sb
      .from('couple_checkins')
      .select()
      .eq('user_id', userId)
      .eq('checkin_date', today)
      .maybeSingle();

  if (data == null) return null;
  return CoupleCheckin.fromJson(data);
});

final coupleCheckinHistoryProvider =
FutureProvider<List<CoupleCheckin>>((ref) async {
  // TODO: fetch history
  return [];
});

class CoupleCheckinController extends AsyncNotifier<CoupleCheckin?> {
  @override
  Future<CoupleCheckin?> build() async => null;

  Future<void> saveCheckin({
    required int scoreConnection,
    required int scoreSatisfaction,
    required int scoreCommunication,
    required EmotionType emotion,
    String? concernText,
    String? gratitudeText,
    String? needText,
    bool gratitudeShared = false,
    bool concernShared = false,
    bool needShared = false,
  }) async {
    state = const AsyncLoading();
    try {
      final svc = ref.read(coupleCheckinServiceProvider);
      final sb = ref.read(supabaseClientProvider);

      // 1. User ID
      final userId = sb.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // 2. Vérifier si check-in déjà fait aujourd'hui
      final today = DateTime.now().toIso8601String().split('T')[0];
      final existing = await sb
          .from('couple_checkins')
          .select('id')
          .eq('user_id', userId)
          .eq('checkin_date', today)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Tu as déjà fait ton check-in aujourd\'hui ! 🎉');
      }

      // 3. Récupérer relation_id depuis relation_members
      final memberResp = await sb
          .from('relation_members')
          .select('relation_id')
          .eq('user_id', userId)
          .limit(1)
          .single();

      final relationId = memberResp['relation_id'] as String;

      // 4. Créer le check-in
      final draft = CoupleCheckin(
        id: '',
        relationId: relationId,
        userId: userId,
        createdAt: DateTime.now(),
        checkinDate: DateTime.now(),
        scoreConnection: scoreConnection,
        scoreSatisfaction: scoreSatisfaction,
        scoreCommunication: scoreCommunication,
        emotion: emotion,
        gratitudeText: gratitudeText,
        gratitudeShared: gratitudeShared,
        concernText: concernText,
        concernShared: concernShared,
        needText: needText,
        needShared: needShared,
        aiTokensUsed: 0,
      );

      final created = await svc.createCheckin(draft);
      state = AsyncData(created);

      // ← AJOUTE CETTE LIGNE
      ref.invalidate(todayCoupleCheckinProvider);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final coupleCheckinNotifierProvider =
    AsyncNotifierProvider<CoupleCheckinController, CoupleCheckin?>(
  CoupleCheckinController.new,
);

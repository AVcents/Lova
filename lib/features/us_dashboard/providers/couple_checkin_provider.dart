import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/us_dashboard/models/couple_checkin.dart';

/// Provider pour le check-in du jour
final todayCoupleCheckinProvider = FutureProvider<CoupleCheckin?>((ref) async {
  // TODO: Appel API pour récupérer le check-in du jour
  // Exemple : return await ref.read(checkinRepositoryProvider).getTodayCheckin();
  return null; // Pour l'instant, retourne null
});

/// Provider pour l'historique des check-ins
final coupleCheckinHistoryProvider = FutureProvider<List<CoupleCheckin>>((ref) async {
  // TODO: Appel API pour récupérer l'historique
  return [];
});

/// Provider pour les statistiques
final coupleCheckinStatsProvider = FutureProvider<CoupleCheckinStats>((ref) async {
  // TODO: Calculer les stats depuis l'historique
  return const CoupleCheckinStats(
    averageConnectionScore: 7.5,
    averageSatisfactionScore: 8.2,
    averageCommunicationScore: 7.0,
    recentCheckins: [],
    totalCheckins: 0,
    currentStreak: 0,
  );
});

/// Notifier pour créer/modifier un check-in
class CoupleCheckinNotifier extends StateNotifier<AsyncValue<CoupleCheckin?>> {
  CoupleCheckinNotifier() : super(const AsyncValue.data(null));

  /// Sauvegarder un nouveau check-in
  Future<void> saveCheckin({
    required int connectionScore,
    required int satisfactionScore,
    required int communicationScore,
    required String emotionToday,
    String? whatWentWell,
    String? whatNeedsAttention,
    String? gratitudeNote,
  }) async {
    state = const AsyncValue.loading();

    try {
      // TODO: Appel API pour sauvegarder
      final checkin = CoupleCheckin(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        coupleId: 'couple_123', // TODO: Récupérer depuis auth
        userId: 'user_123', // TODO: Récupérer depuis auth
        createdAt: DateTime.now(),
        connectionScore: connectionScore,
        satisfactionScore: satisfactionScore,
        communicationScore: communicationScore,
        emotionToday: emotionToday,
        whatWentWell: whatWentWell,
        whatNeedsAttention: whatNeedsAttention,
        gratitudeNote: gratitudeNote,
        isCompleted: true,
        partnerCheckinId: null,
      );

      state = AsyncValue.data(checkin);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final coupleCheckinNotifierProvider =
StateNotifierProvider<CoupleCheckinNotifier, AsyncValue<CoupleCheckin?>>((ref) {
  return CoupleCheckinNotifier();
});
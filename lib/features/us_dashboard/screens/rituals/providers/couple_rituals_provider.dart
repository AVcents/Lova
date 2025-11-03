import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/us_dashboard/screens/rituals/models/couple_ritual.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider pour récupérer le relationId de l'utilisateur actuel
final currentRelationIdProvider = FutureProvider<String?>((ref) async {
  final sb = Supabase.instance.client;
  final userId = sb.auth.currentUser?.id;

  if (userId == null) return null;

  try {
    final memberResp = await sb
        .from('relation_members')
        .select('relation_id')
        .eq('user_id', userId)
        .limit(1)
        .single();

    return memberResp['relation_id'] as String;
  } catch (e) {
    return null;
  }
});

/// Provider pour la liste des rituels disponibles (fetch depuis Supabase)
final coupleRitualsProvider = StateNotifierProvider<CoupleRitualsNotifier, AsyncValue<List<CoupleRitual>>>((ref) {
  final relationIdAsync = ref.watch(currentRelationIdProvider);
  final relationId = relationIdAsync.maybeWhen(
    data: (id) => id,
    orElse: () => null,
  );

  return CoupleRitualsNotifier(relationId);
});

class CoupleRitualsNotifier extends StateNotifier<AsyncValue<List<CoupleRitual>>> {
  final String? relationId;

  CoupleRitualsNotifier(this.relationId) : super(const AsyncValue.loading()) {
    if (relationId != null) {
      _loadRituals();
    }
  }

  Future<void> _loadRituals() async {
    try {
      // Fetch catalog
      final catalogResponse = await Supabase.instance.client
          .from('ritual_catalog')
          .select();

      final rituals = (catalogResponse as List)
          .map((json) => CoupleRitual.fromJson(json as Map<String, dynamic>))
          .toList();

      state = AsyncValue.data(rituals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Toggle favori
  void toggleFavorite(String ritualId) {
    state.whenData((rituals) {
      state = AsyncValue.data(
        rituals.map((r) => r.id == ritualId ? r.copyWith(isFavorite: !r.isFavorite) : r).toList(),
      );
    });
  }

  /// Incrémenter le nombre de complétions
  void incrementCompletion(String ritualId) {
    state.whenData((rituals) {
      state = AsyncValue.data(
        rituals.map((r) => r.id == ritualId
            ? r.copyWith(timesCompleted: r.timesCompleted + 1, currentStreak: r.currentStreak + 1)
            : r).toList(),
      );
    });
  }

  /// Obtenir les rituels favoris
  List<CoupleRitual> getFavorites() {
    return state.maybeWhen(
      data: (rituals) => rituals.where((r) => r.isFavorite).toList(),
      orElse: () => [],
    );
  }

  /// Obtenir les rituels actifs (complétés au moins une fois)
  List<CoupleRitual> getActiveRituals() {
    return state.maybeWhen(
      data: (rituals) => rituals.where((r) => r.timesCompleted > 0).toList(),
      orElse: () => [],
    );
  }

  /// Rafraîchir les données
  Future<void> refresh() => _loadRituals();
}

/// Provider pour les minutes totales de rituels aujourd'hui
final todayCoupleRitualsMinutesProvider = StateProvider<int>((ref) => 0);

/// Provider pour un rituel spécifique
/// Nécessite ritualId
final ritualByIdProvider = Provider.family.autoDispose<CoupleRitual?, String>((ref, ritualId) {
  final ritualsAsync = ref.watch(coupleRitualsProvider);

  return ritualsAsync.maybeWhen(
    data: (rituals) {
      try {
        return rituals.firstWhere((r) => r.id == ritualId);
      } catch (e) {
        return null;
      }
    },
    orElse: () => null,
  );
});

/// Provider pour l'historique des sessions de rituels
final coupleRitualHistoryProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final sb = Supabase.instance.client;
  final userId = sb.auth.currentUser?.id;

  if (userId == null) return [];

  try {
    // Récupérer relation_id
    final memberResp = await sb
        .from('relation_members')
        .select('relation_id')
        .eq('user_id', userId)
        .limit(1)
        .single();

    final relationId = memberResp['relation_id'] as String;

    // Fetch sessions avec JOIN ritual_catalog
    final response = await sb
        .from('couple_ritual_sessions')
        .select('''
          id,
          ritual_id,
          duration_actual_minutes,
          completed_at,
          ritual_catalog!inner(title, emoji, slug, category)
        ''')
        .eq('relation_id', relationId)
        .order('completed_at', ascending: false)
        .limit(30);

    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  } catch (e) {
    return [];
  }
});
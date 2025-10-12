import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/us_dashboard/screens/rituals/models/couple_ritual.dart';
import 'package:lova/features/us_dashboard/screens/rituals/data/couple_rituals_data.dart';

/// Provider pour la liste des rituels disponibles
final coupleRitualsProvider = StateNotifierProvider<CoupleRitualsNotifier, List<CoupleRitual>>((ref) {
  return CoupleRitualsNotifier();
});

class CoupleRitualsNotifier extends StateNotifier<List<CoupleRitual>> {
  CoupleRitualsNotifier() : super(CoupleRitualsData.getAllRituals());

  /// Toggle favori
  void toggleFavorite(String ritualId) {
    state = state.map((ritual) {
      if (ritual.id == ritualId) {
        return ritual.copyWith(isFavorite: !ritual.isFavorite);
      }
      return ritual;
    }).toList();
  }

  /// Incrémenter le nombre de complétions
  void incrementCompletion(String ritualId) {
    state = state.map((ritual) {
      if (ritual.id == ritualId) {
        return ritual.copyWith(
          timesCompleted: ritual.timesCompleted + 1,
          currentStreak: ritual.currentStreak + 1,
        );
      }
      return ritual;
    }).toList();
  }

  /// Obtenir les rituels favoris
  List<CoupleRitual> getFavorites() {
    return state.where((r) => r.isFavorite).toList();
  }

  /// Obtenir les rituels actifs (complétés au moins une fois)
  List<CoupleRitual> getActiveRituals() {
    return state.where((r) => r.timesCompleted > 0).toList();
  }
}

/// Provider pour les minutes totales de rituels aujourd'hui
final todayCoupleRitualsMinutesProvider = StateProvider<int>((ref) => 0);

/// Provider pour un rituel spécifique
final ritualByIdProvider = Provider.family<CoupleRitual?, String>((ref, id) {
  final rituals = ref.watch(coupleRitualsProvider);
  try {
    return rituals.firstWhere((r) => r.id == id);
  } catch (e) {
    return null;
  }
});
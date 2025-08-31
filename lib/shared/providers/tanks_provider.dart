import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tanks_persistence.dart';

/// Types d'actions pour le Love Tank (US)
enum LoveTankAction {
  planMoment(8),        // +8 points
  sendAttention(5),     // +5 points
  mediationCompleted(6), // +6 points
  duoCheckin(4),        // +4 points
  applyAdvice(3);       // +3 points

  final int points;
  const LoveTankAction(this.points);
}

/// Types d'actions pour le Me Tank
enum MeTankAction {
  moodCheckin(3),       // +3 points
  breath1min(3),        // +3 points
  journalGratitude(4),  // +4 points
  move5min(2);          // +2 points

  final int points;
  const MeTankAction(this.points);
}

/// État du Love Tank
class LoveTankState {
  final int value;
  final DateTime? lastActionAt;
  final int streakDays;

  const LoveTankState({
    required this.value,
    this.lastActionAt,
    required this.streakDays,
  });

  LoveTankState copyWith({
    int? value,
    DateTime? lastActionAt,
    int? streakDays,
  }) {
    return LoveTankState(
      value: value ?? this.value,
      lastActionAt: lastActionAt ?? this.lastActionAt,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

/// État du Me Tank
class MeTankState {
  final int value;
  final DateTime? lastActionAt;
  final int streakDays;

  const MeTankState({
    required this.value,
    this.lastActionAt,
    required this.streakDays,
  });

  MeTankState copyWith({
    int? value,
    DateTime? lastActionAt,
    int? streakDays,
  }) {
    return MeTankState(
      value: value ?? this.value,
      lastActionAt: lastActionAt ?? this.lastActionAt,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

/// Notifier pour gérer l'état du Love Tank
class LoveTankNotifier extends StateNotifier<LoveTankState> {
  final TanksPersistence _persistence;
  static const int _dailyDecay = 2;
  static const int _streakBonus = 5;
  static const int _streakInterval = 7;

  LoveTankNotifier(this._persistence)
      : super(const LoveTankState(value: 50, streakDays: 0)) {
    _loadState();
  }

  Future<void> _loadState() async {
    final data = await _persistence.loadLoveTank();
    state = LoveTankState(
      value: data.value,
      lastActionAt: data.lastActionAt,
      streakDays: data.streakDays,
    );

    // Appliquer le decay au chargement si nécessaire
    applyDailyDecayIfNeeded();
  }

  /// Incrémente la jauge selon l'action effectuée
  Future<void> incrementBy(LoveTankAction action) async {
    final now = DateTime.now();
    final lastAction = state.lastActionAt;

    // Calcul du streak
    int newStreak = state.streakDays;
    if (lastAction != null) {
      final daysSinceLastAction = now.difference(lastAction).inDays;
      if (daysSinceLastAction == 1) {
        // Action consécutive
        newStreak++;
      } else if (daysSinceLastAction > 1) {
        // Streak cassé
        newStreak = 1;
      }
      // Si même jour, on garde le streak actuel
    } else {
      // Première action
      newStreak = 1;
    }

    // Calcul des points avec bonus de streak
    int pointsToAdd = action.points;
    if (newStreak > 0 && newStreak % _streakInterval == 0) {
      pointsToAdd += _streakBonus;
    }

    // Mise à jour de l'état
    final newValue = (state.value + pointsToAdd).clamp(0, 100);
    state = state.copyWith(
      value: newValue,
      lastActionAt: now,
      streakDays: newStreak,
    );

    // Sauvegarde
    await _persistence.saveLoveTank(LoveTankData(
      value: newValue,
      lastActionAt: now,
      streakDays: newStreak,
    ));
  }

  /// Applique le decay quotidien si nécessaire
  Future<void> applyDailyDecayIfNeeded() async {
    if (state.lastActionAt == null) return;

    final now = DateTime.now();
    final daysSinceLastAction = now.difference(state.lastActionAt!).inDays;

    if (daysSinceLastAction >= 1) {
      final decay = daysSinceLastAction * _dailyDecay;
      final newValue = (state.value - decay).clamp(0, 100);

      // Reset du streak si plus d'un jour sans action
      final newStreak = daysSinceLastAction > 1 ? 0 : state.streakDays;

      state = state.copyWith(
        value: newValue,
        streakDays: newStreak,
      );

      await _persistence.saveLoveTank(LoveTankData(
        value: newValue,
        lastActionAt: state.lastActionAt,
        streakDays: newStreak,
      ));
    }
  }

  /// Réinitialise si la valeur est invalide
  void resetIfInvalid() {
    if (state.value < 0 || state.value > 100) {
      state = state.copyWith(value: state.value.clamp(0, 100));
    }
  }
}

/// Notifier pour gérer l'état du Me Tank
class MeTankNotifier extends StateNotifier<MeTankState> {
  final TanksPersistence _persistence;
  static const int _dailyDecay = 1;
  static const int _streakBonus = 3;
  static const int _streakInterval = 7;

  MeTankNotifier(this._persistence)
      : super(const MeTankState(value: 50, streakDays: 0)) {
    _loadState();
  }

  Future<void> _loadState() async {
    final data = await _persistence.loadMeTank();
    state = MeTankState(
      value: data.value,
      lastActionAt: data.lastActionAt,
      streakDays: data.streakDays,
    );

    // Appliquer le decay au chargement si nécessaire
    applyDailyDecayIfNeeded();
  }

  /// Incrémente la jauge selon l'action effectuée
  Future<void> incrementBy(MeTankAction action) async {
    final now = DateTime.now();
    final lastAction = state.lastActionAt;

    // Calcul du streak
    int newStreak = state.streakDays;
    if (lastAction != null) {
      final daysSinceLastAction = now.difference(lastAction).inDays;
      if (daysSinceLastAction == 1) {
        // Action consécutive
        newStreak++;
      } else if (daysSinceLastAction > 1) {
        // Streak cassé
        newStreak = 1;
      }
      // Si même jour, on garde le streak actuel
    } else {
      // Première action
      newStreak = 1;
    }

    // Calcul des points avec bonus de streak
    int pointsToAdd = action.points;
    if (newStreak > 0 && newStreak % _streakInterval == 0) {
      pointsToAdd += _streakBonus;
    }

    // Mise à jour de l'état
    final newValue = (state.value + pointsToAdd).clamp(0, 100);
    state = state.copyWith(
      value: newValue,
      lastActionAt: now,
      streakDays: newStreak,
    );

    // Sauvegarde
    await _persistence.saveMeTank(MeTankData(
      value: newValue,
      lastActionAt: now,
      streakDays: newStreak,
    ));
  }

  /// Applique le decay quotidien si nécessaire
  Future<void> applyDailyDecayIfNeeded() async {
    if (state.lastActionAt == null) return;

    final now = DateTime.now();
    final daysSinceLastAction = now.difference(state.lastActionAt!).inDays;

    if (daysSinceLastAction >= 1) {
      final decay = daysSinceLastAction * _dailyDecay;
      final newValue = (state.value - decay).clamp(0, 100);

      // Reset du streak si plus d'un jour sans action
      final newStreak = daysSinceLastAction > 1 ? 0 : state.streakDays;

      state = state.copyWith(
        value: newValue,
        streakDays: newStreak,
      );

      await _persistence.saveMeTank(MeTankData(
        value: newValue,
        lastActionAt: state.lastActionAt,
        streakDays: newStreak,
      ));
    }
  }

  /// Réinitialise si la valeur est invalide
  void resetIfInvalid() {
    if (state.value < 0 || state.value > 100) {
      state = state.copyWith(value: state.value.clamp(0, 100));
    }
  }
}

/// Provider pour le service de persistance
final tanksPersistenceProvider = Provider<TanksPersistence>((ref) {
  throw UnimplementedError('tanksPersistenceProvider must be overridden');
});

/// Provider pour l'état du Love Tank
final loveTankProvider = StateNotifierProvider<LoveTankNotifier, LoveTankState>((ref) {
  final persistence = ref.watch(tanksPersistenceProvider);
  return LoveTankNotifier(persistence);
});

/// Provider pour l'état du Me Tank
final meTankProvider = StateNotifierProvider<MeTankNotifier, MeTankState>((ref) {
  final persistence = ref.watch(tanksPersistenceProvider);
  return MeTankNotifier(persistence);
});
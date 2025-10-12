// lib/features/me_dashboard/providers/me_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/features/me_dashboard/data/me_repository.dart';
import 'package:lova/features/me_dashboard/data/models/me_checkin_model.dart';
import 'package:lova/features/me_dashboard/data/models/me_streak_model.dart';
import 'package:lova/features/me_dashboard/data/models/me_metrics_model.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

final meRepositoryProvider = Provider<MeRepository>((ref) {
  return MeRepository(Supabase.instance.client);
});

// ============================================
// CHECK-IN PROVIDERS
// ============================================

/// Provider pour le check-in d'aujourd'hui
final todayCheckinProvider = FutureProvider<MeCheckin?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getTodayCheckin();
});

/// Notifier pour créer un check-in
final checkinNotifierProvider =
StateNotifierProvider<CheckinNotifier, AsyncValue<MeCheckin?>>((ref) {
  return CheckinNotifier(ref.watch(meRepositoryProvider));
});

class CheckinNotifier extends StateNotifier<AsyncValue<MeCheckin?>> {
  final MeRepository _repository;

  CheckinNotifier(this._repository) : super(const AsyncValue.loading());

  /// Créer un check-in
  Future<bool> createCheckin({
    required int mood,
    String? trigger,
    String? note,
  }) async {
    state = const AsyncValue.loading();

    try {
      final checkin = await _repository.createCheckin(
        mood: mood,
        trigger: trigger,
        note: note,
      );

      if (checkin == null) {
        // Déjà fait aujourd'hui
        state = AsyncValue.error(
          'Check-in déjà effectué aujourd\'hui',
          StackTrace.current,
        );
        return false;
      }

      state = AsyncValue.data(checkin);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Récupérer le check-in d'aujourd'hui
  Future<void> loadTodayCheckin() async {
    state = const AsyncValue.loading();

    try {
      final checkin = await _repository.getTodayCheckin();
      state = AsyncValue.data(checkin);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider pour l'historique des check-ins
final checkinsHistoryProvider =
FutureProvider.family<List<MeCheckin>, int>((ref, days) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getCheckinsHistory(days: days);
});

// ============================================
// STREAK PROVIDERS
// ============================================

/// Provider pour le streak (temps réel via stream)
final streakProvider = StreamProvider<MeStreak?>((ref) {
  final repository = ref.watch(meRepositoryProvider);
  return repository.watchStreak();
});

/// Provider pour récupérer le streak une seule fois
final currentStreakProvider = FutureProvider<MeStreak?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getStreak();
});

// ============================================
// METRICS PROVIDERS
// ============================================

/// Provider pour les métriques de la semaine (temps réel via stream)
final weekMetricsProvider = StreamProvider<MeMetrics?>((ref) {
  final repository = ref.watch(meRepositoryProvider);
  return repository.watchCurrentWeekMetrics();
});

/// Provider pour récupérer les métriques une seule fois
final currentWeekMetricsProvider = FutureProvider<MeMetrics?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getCurrentWeekMetrics();
});

// ============================================
// ACTIONS PROVIDERS
// ============================================

/// Notifier pour créer des actions/rituels
final actionsNotifierProvider =
StateNotifierProvider<ActionsNotifier, AsyncValue<void>>((ref) {
  return ActionsNotifier(ref.watch(meRepositoryProvider));
});

class ActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final MeRepository _repository;

  ActionsNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Créer une action
  Future<bool> createAction({
    required String type,
    required String title,
    required int durationMin,
    String? notes,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.createAction(
        type: type,
        title: title,
        durationMin: durationMin,
        notes: notes,
      );

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Récupérer les minutes utilisées aujourd'hui
  Future<int> getTodayMinutesUsed() async {
    return _repository.getTodayRitualsMinutes();
  }
}

/// Provider pour les actions du jour
final todayActionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getTodayActions();
});

/// Provider pour les minutes utilisées aujourd'hui
final todayRitualsMinutesProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getTodayRitualsMinutes();
});

// ============================================
// JOURNAL PROVIDERS
// ============================================

/// Notifier pour créer des entrées de journal
final journalNotifierProvider =
StateNotifierProvider<JournalNotifier, AsyncValue<void>>((ref) {
  return JournalNotifier(ref.watch(meRepositoryProvider));
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final MeRepository _repository;

  JournalNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Créer une entrée de journal
  Future<bool> createEntry({
    required String text,
    List<String>? tags,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.createJournalEntry(
        text: text,
        tags: tags,
      );

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Provider pour le journal d'aujourd'hui
final todayJournalProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  return repository.getTodayJournal();
});

// ============================================
// NOTIFICATIONS ACTION BAR - NOUVEAUX PROVIDERS
// ============================================

/// Provider pour vérifier si un rituel a été fait aujourd'hui
final todayRitualProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(meRepositoryProvider);
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  final rituals = await repository.getActionsHistory(days: 1);

  if (rituals.isEmpty) return null;

  // Trouver le premier rituel d'aujourd'hui
  for (final ritual in rituals) {
    final timestamp = DateTime.parse(ritual['ts'] as String);
    if (timestamp.isAfter(startOfDay) || timestamp.isAtSameMomentAs(startOfDay)) {
      return ritual;
    }
  }

  return null;
});

// ============================================
// HISTORIQUES PROVIDERS
// ============================================

/// Historique du journal sur N jours (par défaut 30)
final journalsHistoryProvider =
FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, days) async {
  final repository = ref.watch(meRepositoryProvider);
  final safeDays = days <= 0 ? 30 : days;
  final list = await repository.getJournalsHistory(days: safeDays);
  return list;
});

/// Historique des rituels/actions sur N jours (par défaut 30)
final ritualsHistoryProvider =
FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>((ref, days) async {
  final repository = ref.watch(meRepositoryProvider);
  final safeDays = days <= 0 ? 30 : days;
  final list = await repository.getActionsHistory(days: safeDays);
  return list;
});

// ============================================
// HELPER: État des limites quotidiennes
// ============================================

/// Provider qui combine les infos pour savoir ce qui est disponible aujourd'hui
final dailyLimitsProvider = FutureProvider<DailyLimits>((ref) async {
  final repository = ref.watch(meRepositoryProvider);

  final checkin = await repository.getTodayCheckin();
  final ritualsMinutes = await repository.getTodayRitualsMinutes();
  final journal = await repository.getTodayJournal();

  return DailyLimits(
    checkinDone: checkin != null,
    ritualsMinutesUsed: ritualsMinutes,
    ritualsMinutesRemaining: 30 - ritualsMinutes,
    journalDone: journal != null,
  );
});

class DailyLimits {
  final bool checkinDone;
  final int ritualsMinutesUsed;
  final int ritualsMinutesRemaining;
  final bool journalDone;

  DailyLimits({
    required this.checkinDone,
    required this.ritualsMinutesUsed,
    required this.ritualsMinutesRemaining,
    required this.journalDone,
  });

  bool get canDoCheckin => !checkinDone;
  bool get canDoRituals => ritualsMinutesRemaining > 0;
  bool get canDoJournal => !journalDone;
}
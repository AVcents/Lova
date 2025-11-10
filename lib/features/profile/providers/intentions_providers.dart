// lib/features/profile/providers/intentions_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/features/profile/data/intentions_repository.dart';
import 'package:lova/features/profile/data/models/life_intention_model.dart';
import 'package:lova/features/profile/data/models/intention_progress_model.dart';
import 'package:lova/features/profile/data/models/intention_reflection_model.dart';

// ============================================
// REPOSITORY PROVIDER
// ============================================

final intentionsRepositoryProvider = Provider<IntentionsRepository>((ref) {
  return IntentionsRepository(Supabase.instance.client);
});

// ============================================
// INTENTIONS PROVIDERS
// ============================================

/// Provider pour toutes les intentions actives
final activeIntentionsProvider = FutureProvider<List<LifeIntention>>((ref) async {
  final repository = ref.watch(intentionsRepositoryProvider);
  return repository.getActiveIntentions();
});

/// Provider pour les intentions par statut
final intentionsByStatusProvider = FutureProvider.family<List<LifeIntention>, IntentionStatus>(
      (ref, status) async {
    final repository = ref.watch(intentionsRepositoryProvider);
    return repository.getIntentionsByStatus(status);
  },
);

/// Provider pour une intention spécifique
final intentionByIdProvider = FutureProvider.family<LifeIntention?, String>(
      (ref, intentionId) async {
    final repository = ref.watch(intentionsRepositoryProvider);
    return repository.getIntentionById(intentionId);
  },
);

/// Provider pour l'intention principale du dashboard
final primaryActiveIntentionProvider = FutureProvider<LifeIntention?>((ref) async {
  final repository = ref.watch(intentionsRepositoryProvider);
  return repository.getPrimaryIntention();
});

/// Provider pour les statistiques globales
final intentionsStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(intentionsRepositoryProvider);
  return repository.getIntentionsStats();
});

// ============================================
// PROGRESS PROVIDERS
// ============================================

/// Provider pour l'historique de progrès d'une intention
final intentionProgressProvider = FutureProvider.family<List<IntentionProgress>, String>(
      (ref, intentionId) async {
    final repository = ref.watch(intentionsRepositoryProvider);
    return repository.getIntentionProgress(intentionId);
  },
);

// ============================================
// REFLECTION PROVIDERS
// ============================================

/// Provider pour une réflexion spécifique (année, mois)
final reflectionProvider = FutureProvider.family<IntentionReflection?, Map<String, int>>(
      (ref, params) async {
    final repository = ref.watch(intentionsRepositoryProvider);
    return repository.getReflection(
      year: params['year']!,
      month: params['month']!,
    );
  },
);

/// Provider pour la réflexion du mois dernier
final lastMonthReflectionProvider = FutureProvider<IntentionReflection?>((ref) async {
  final repository = ref.watch(intentionsRepositoryProvider);
  final now = DateTime.now();
  final lastMonth = DateTime(now.year, now.month - 1);

  return repository.getReflection(
    year: lastMonth.year,
    month: lastMonth.month,
  );
});

/// Provider pour toutes les réflexions
final allReflectionsProvider = FutureProvider<List<IntentionReflection>>((ref) async {
  final repository = ref.watch(intentionsRepositoryProvider);
  return repository.getAllReflections();
});

// ============================================
// NOTIFIER POUR LES ACTIONS
// ============================================

final intentionsNotifierProvider = StateNotifierProvider<IntentionsNotifier, AsyncValue<void>>(
      (ref) => IntentionsNotifier(ref.watch(intentionsRepositoryProvider), ref),
);

class IntentionsNotifier extends StateNotifier<AsyncValue<void>> {
  final IntentionsRepository _repository;
  final Ref _ref;

  IntentionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Créer une nouvelle intention
  Future<bool> createIntention(LifeIntention intention) async {
    state = const AsyncValue.loading();

    try {
      await _repository.createIntention(intention);
      state = const AsyncValue.data(null);

      // Invalider les providers pour rafraîchir l'UI
      _ref.invalidate(activeIntentionsProvider);
      _ref.invalidate(primaryActiveIntentionProvider);
      _ref.invalidate(intentionsStatsProvider);

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Mettre à jour une intention
  Future<bool> updateIntention(String intentionId, Map<String, dynamic> updates) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateIntention(intentionId, updates);
      state = const AsyncValue.data(null);

      _ref.invalidate(activeIntentionsProvider);
      _ref.invalidate(intentionByIdProvider(intentionId));
      _ref.invalidate(primaryActiveIntentionProvider);

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Changer le statut d'une intention
  Future<bool> updateStatus(String intentionId, IntentionStatus newStatus) async {
    state = const AsyncValue.loading();

    try {
      final success = await _repository.updateIntentionStatus(intentionId, newStatus);
      state = const AsyncValue.data(null);

      if (success) {
        _ref.invalidate(activeIntentionsProvider);
        _ref.invalidate(intentionByIdProvider(intentionId));
        _ref.invalidate(primaryActiveIntentionProvider);
        _ref.invalidate(intentionsStatsProvider);
      }

      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Ajouter du progrès
  Future<bool> addProgress({
    required String intentionId,
    int incrementValue = 1,
    String? note,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.addProgress(
        intentionId: intentionId,
        incrementValue: incrementValue,
        note: note,
      );

      state = const AsyncValue.data(null);

      // Invalider pour rafraîchir
      _ref.invalidate(intentionByIdProvider(intentionId));
      _ref.invalidate(intentionProgressProvider(intentionId));
      _ref.invalidate(activeIntentionsProvider);
      _ref.invalidate(primaryActiveIntentionProvider);

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Supprimer une intention
  Future<bool> deleteIntention(String intentionId) async {
    state = const AsyncValue.loading();

    try {
      final success = await _repository.deleteIntention(intentionId);
      state = const AsyncValue.data(null);

      if (success) {
        _ref.invalidate(activeIntentionsProvider);
        _ref.invalidate(primaryActiveIntentionProvider);
        _ref.invalidate(intentionsStatsProvider);
      }

      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Sauvegarder une réflexion
  Future<bool> saveReflection(IntentionReflection reflection) async {
    state = const AsyncValue.loading();

    try {
      await _repository.upsertReflection(reflection);
      state = const AsyncValue.data(null);

      _ref.invalidate(allReflectionsProvider);
      _ref.invalidate(reflectionProvider({
        'year': reflection.year,
        'month': reflection.month,
      }));

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Archiver les intentions expirées
  Future<void> archiveExpired() async {
    await _repository.archiveExpiredIntentions();
    _ref.invalidate(activeIntentionsProvider);
    _ref.invalidate(primaryActiveIntentionProvider);
  }
}
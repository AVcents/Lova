// lib/shared/providers/annotations_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_annotation.dart';
import '../repositories/annotations_repository.dart';
import '../repositories/annotations_repository_memory.dart';

/// Provider pour le repository des annotations
final annotationsRepositoryProvider = Provider<AnnotationsRepository>((ref) {
  // Pour le sprint 1, on utilise l'implémentation mémoire
  // Plus tard, on pourra basculer sur Supabase ici
  throw UnimplementedError(
    'annotationsRepositoryProvider must be overridden in main.dart',
  );
});

/// Provider pour récupérer les annotations d'un message
final annotationsByMessageProvider = FutureProvider.family<List<MessageAnnotation>, int>(
      (ref, messageId) async {
    final repository = ref.watch(annotationsRepositoryProvider);
    return repository.listByMessage(messageId);
  },
);

/// Paramètres pour filtrer les annotations d'un couple
class AnnotationFilter {
  final String coupleId;
  final AnnotationTag? filter;
  final String? query;

  const AnnotationFilter({
    required this.coupleId,
    this.filter,
    this.query,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnotationFilter &&
        other.coupleId == coupleId &&
        other.filter == filter &&
        other.query == query;
  }

  @override
  int get hashCode => Object.hash(coupleId, filter, query);
}

/// Provider pour récupérer les annotations filtrées d'un couple
final annotationsByCoupleProvider = FutureProvider.family<List<MessageAnnotation>, AnnotationFilter>(
      (ref, params) async {
    final repository = ref.watch(annotationsRepositoryProvider);
    return repository.listByCouple(
      params.coupleId,
      filter: params.filter,
      query: params.query,
    );
  },
);

/// StateNotifier pour gérer les opérations sur les annotations
class AnnotationsNotifier extends StateNotifier<AsyncValue<void>> {
  final AnnotationsRepository _repository;
  final Ref _ref;

  AnnotationsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// Ajoute une nouvelle annotation
  Future<void> addAnnotation(MessageAnnotation annotation) async {
    state = const AsyncValue.loading();
    try {
      // Vérifier si l'utilisateur a déjà ce tag sur ce message
      final hasTag = await _repository.hasUserTag(
        annotation.messageId,
        annotation.authorUserId,
        annotation.tag,
      );

      if (hasTag) {
        state = AsyncValue.error(
          'Vous avez déjà ajouté ce tag à ce message',
          StackTrace.current,
        );
        return;
      }

      await _repository.add(annotation);

      // Invalider les caches pour forcer le refresh
      _ref.invalidate(annotationsByMessageProvider(annotation.messageId));
      _ref.invalidate(annotationsByCoupleProvider);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Supprime une annotation
  Future<void> removeAnnotation(String annotationId) async {
    state = const AsyncValue.loading();
    try {
      // Récupérer l'annotation pour avoir ses infos avant suppression
      final annotation = await _repository.getById(annotationId);

      await _repository.remove(annotationId);

      // Invalider les caches concernés
      if (annotation != null) {
        _ref.invalidate(annotationsByMessageProvider(annotation.messageId));
        _ref.invalidate(annotationsByCoupleProvider);
      }

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Met à jour une annotation (pour ajouter/modifier une note)
  Future<void> updateAnnotation(MessageAnnotation annotation) async {
    state = const AsyncValue.loading();
    try {
      await _repository.update(annotation);

      // Invalider les caches
      _ref.invalidate(annotationsByMessageProvider(annotation.messageId));
      _ref.invalidate(annotationsByCoupleProvider);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider pour le notifier des annotations
final annotationsNotifierProvider = StateNotifierProvider<AnnotationsNotifier, AsyncValue<void>>(
      (ref) {
    final repository = ref.watch(annotationsRepositoryProvider);
    return AnnotationsNotifier(repository, ref);
  },
);

/// Provider pour compter les annotations d'un couple
final annotationsCountProvider = FutureProvider.family<int, AnnotationFilter>(
      (ref, params) async {
    final repository = ref.watch(annotationsRepositoryProvider);
    return repository.countByCouple(
      params.coupleId,
      filter: params.filter,
    );
  },
);
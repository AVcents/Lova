// lib/shared/repositories/annotations_repository.dart

import '../models/message_annotation.dart';

/// Interface pour le repository des annotations de messages
abstract class AnnotationsRepository {
  /// Liste toutes les annotations d'un couple, avec filtres optionnels
  Future<List<MessageAnnotation>> listByCouple(
      String coupleId, {
        AnnotationTag? filter,
        String? query,
      });

  /// Liste toutes les annotations d'un message spécifique
  Future<List<MessageAnnotation>> listByMessage(int messageId);

  /// Ajoute une nouvelle annotation
  Future<void> add(MessageAnnotation annotation);

  /// Supprime une annotation par son ID
  Future<void> remove(String annotationId);

  /// Met à jour une annotation existante
  Future<void> update(MessageAnnotation annotation);

  /// Récupère une annotation par son ID
  Future<MessageAnnotation?> getById(String annotationId);

  /// Vérifie si un message a déjà un tag spécifique par un utilisateur
  Future<bool> hasUserTag(int messageId, String userId, AnnotationTag tag);

  /// Compte le nombre d'annotations pour un couple
  Future<int> countByCouple(String coupleId, {AnnotationTag? filter});
}
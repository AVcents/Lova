// lib/shared/repositories/annotations_repository_memory.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/repositories/annotations_repository.dart';

/// Implémentation en mémoire du repository des annotations
/// avec persistance locale via SharedPreferences
class AnnotationsRepositoryMemory implements AnnotationsRepository {
  static const String _storageKey = 'message_annotations';
  final SharedPreferences _prefs;
  List<MessageAnnotation> _annotations = [];

  AnnotationsRepositoryMemory(this._prefs) {
    _loadFromStorage();
  }

  /// Factory pour créer une instance avec les préférences
  static Future<AnnotationsRepositoryMemory> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AnnotationsRepositoryMemory(prefs);
  }

  /// Charge les annotations depuis le stockage local
  void _loadFromStorage() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _annotations = jsonList
            .map(
              (json) => MessageAnnotation.fromMap(json as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        print('Erreur lors du chargement des annotations: $e');
        _annotations = [];
      }
    }
  }

  /// Sauvegarde les annotations dans le stockage local
  Future<void> _saveToStorage() async {
    final jsonList = _annotations.map((ann) => ann.toMap()).toList();
    final jsonString = json.encode(jsonList);
    await _prefs.setString(_storageKey, jsonString);
  }

  @override
  Future<List<MessageAnnotation>> listByCouple(
    String coupleId, {
    AnnotationTag? filter,
    String? query,
  }) async {
    var results = _annotations.where((ann) => ann.coupleId == coupleId);

    // Filtre par tag si spécifié
    if (filter != null) {
      results = results.where((ann) => ann.tag == filter);
    }

    // Recherche textuelle dans les notes si query spécifiée
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results.where((ann) {
        final noteMatch = ann.note?.toLowerCase().contains(lowerQuery) ?? false;
        return noteMatch;
      });
    }

    // Tri par date de création (plus récent en premier)
    final sortedResults = results.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedResults;
  }

  @override
  Future<List<MessageAnnotation>> listByMessage(int messageId) async {
    final results =
        _annotations.where((ann) => ann.messageId == messageId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return results;
  }

  @override
  Future<void> add(MessageAnnotation annotation) async {
    _annotations.add(annotation);
    await _saveToStorage();
  }

  @override
  Future<void> remove(String annotationId) async {
    _annotations.removeWhere((ann) => ann.id == annotationId);
    await _saveToStorage();
  }

  @override
  Future<void> update(MessageAnnotation annotation) async {
    final index = _annotations.indexWhere((ann) => ann.id == annotation.id);
    if (index != -1) {
      _annotations[index] = annotation;
      await _saveToStorage();
    }
  }

  @override
  Future<MessageAnnotation?> getById(String annotationId) async {
    try {
      return _annotations.firstWhere((ann) => ann.id == annotationId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> hasUserTag(
    int messageId,
    String userId,
    AnnotationTag tag,
  ) async {
    return _annotations.any(
      (ann) =>
          ann.messageId == messageId &&
          ann.authorUserId == userId &&
          ann.tag == tag,
    );
  }

  @override
  Future<int> countByCouple(String coupleId, {AnnotationTag? filter}) async {
    var results = _annotations.where((ann) => ann.coupleId == coupleId);

    if (filter != null) {
      results = results.where((ann) => ann.tag == filter);
    }

    return results.length;
  }

  /// Efface toutes les annotations (utile pour les tests)
  Future<void> clearAll() async {
    _annotations.clear();
    await _prefs.remove(_storageKey);
  }

  /// Récupère toutes les annotations (utile pour debug)
  List<MessageAnnotation> get allAnnotations => List.unmodifiable(_annotations);
}

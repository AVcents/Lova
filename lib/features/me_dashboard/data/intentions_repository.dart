// lib/features/me_dashboard/data/intentions_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/me_dashboard/data/models/life_intention_model.dart';
import 'package:lova/features/me_dashboard/data/models/intention_progress_model.dart';
import 'package:lova/features/me_dashboard/data/models/intention_reflection_model.dart';

class IntentionsRepository {
  final SupabaseClient _supabase;

  IntentionsRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // ============================================
  // INTENTIONS - CRUD
  // ============================================

  /// Créer une nouvelle intention
  Future<LifeIntention> createIntention(LifeIntention intention) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final jsonData = intention.toJson();

      // ✅ CORRECTION : Ajouter le user_id depuis le repository
      jsonData['user_id'] = _currentUserId!;

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔍 JSON envoyé à Supabase:');
      print(jsonData);
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await _supabase
          .from('me_life_intentions')
          .insert(jsonData)
          .select()
          .single();

      return LifeIntention.fromJson(response);
    } catch (e) {
      print('❌ ERREUR COMPLÈTE: $e');
      if (e.toString().contains('Maximum')) {
        throw Exception('Limite d\'intentions atteinte pour ce type');
      }
      rethrow;
    }
  }

  /// Récupérer toutes les intentions actives
  Future<List<LifeIntention>> getActiveIntentions() async {
    if (_currentUserId == null) return [];

    try {
      final response = await _supabase
          .from('me_life_intentions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => LifeIntention.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching active intentions: $e');
      return [];
    }
  }

  /// Récupérer les intentions par statut
  Future<List<LifeIntention>> getIntentionsByStatus(
      IntentionStatus status) async {
    if (_currentUserId == null) return [];

    try {
      final response = await _supabase
          .from('me_life_intentions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('status', status.name)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => LifeIntention.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching intentions by status: $e');
      return [];
    }
  }

  /// Récupérer une intention spécifique avec détails
  Future<LifeIntention?> getIntentionById(String intentionId) async {
    if (_currentUserId == null) return null;

    try {
      final response = await _supabase
          .from('me_life_intentions')
          .select()
          .eq('id', intentionId)
          .eq('user_id', _currentUserId!)
          .maybeSingle();

      if (response == null) return null;
      return LifeIntention.fromJson(response);
    } catch (e) {
      print('Error fetching intention: $e');
      return null;
    }
  }

  /// Mettre à jour une intention
  Future<LifeIntention?> updateIntention(
      String intentionId, Map<String, dynamic> updates) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final response = await _supabase
          .from('me_life_intentions')
          .update({...updates, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', intentionId)
          .eq('user_id', _currentUserId!)
          .select()
          .single();

      return LifeIntention.fromJson(response);
    } catch (e) {
      print('Error updating intention: $e');
      return null;
    }
  }

  /// Changer le statut d'une intention
  Future<bool> updateIntentionStatus(
      String intentionId, IntentionStatus newStatus) async {
    if (_currentUserId == null) return false;

    try {
      final updates = <String, dynamic>{
        'status': newStatus.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (newStatus == IntentionStatus.completed) {
        updates['completed_at'] = DateTime.now().toIso8601String();
      }

      await _supabase
          .from('me_life_intentions')
          .update(updates)
          .eq('id', intentionId)
          .eq('user_id', _currentUserId!);

      return true;
    } catch (e) {
      print('Error updating intention status: $e');
      return false;
    }
  }

  /// Supprimer une intention
  Future<bool> deleteIntention(String intentionId) async {
    if (_currentUserId == null) return false;

    try {
      await _supabase
          .from('me_life_intentions')
          .delete()
          .eq('id', intentionId)
          .eq('user_id', _currentUserId!);

      return true;
    } catch (e) {
      print('Error deleting intention: $e');
      return false;
    }
  }

  // ============================================
  // PROGRESS - CRUD
  // ============================================

  /// Ajouter du progrès à une intention
  Future<IntentionProgress?> addProgress({
    required String intentionId,
    int incrementValue = 1,
    String? note,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final now = DateTime.now();
      final response = await _supabase
          .from('me_intention_progress')
          .insert({
        'intention_id': intentionId,
        'user_id': _currentUserId,
        'ts': now.toIso8601String(),
        'progress_date': now.toIso8601String().split('T')[0],
        'increment_value': incrementValue,
        'note': note,
        'source': 'manual',
      })
          .select()
          .single();

      return IntentionProgress.fromJson(response);
    } catch (e) {
      if (e.toString().contains('duplicate') || e.toString().contains('unique')) {
        throw Exception('Progrès déjà enregistré aujourd\'hui');
      }
      rethrow;
    }
  }

  /// Récupérer l'historique de progrès d'une intention
  Future<List<IntentionProgress>> getIntentionProgress(
      String intentionId) async {
    if (_currentUserId == null) return [];

    try {
      final response = await _supabase
          .from('me_intention_progress')
          .select()
          .eq('intention_id', intentionId)
          .eq('user_id', _currentUserId!)
          .order('progress_date', ascending: false)
          .limit(100);

      return (response as List)
          .map((json) => IntentionProgress.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching intention progress: $e');
      return [];
    }
  }

  /// Supprimer une entrée de progrès
  Future<bool> deleteProgress(String progressId) async {
    if (_currentUserId == null) return false;

    try {
      await _supabase
          .from('me_intention_progress')
          .delete()
          .eq('id', progressId)
          .eq('user_id', _currentUserId!);

      return true;
    } catch (e) {
      print('Error deleting progress: $e');
      return false;
    }
  }

  // ============================================
  // REFLECTIONS - CRUD
  // ============================================

  /// Créer ou mettre à jour une réflexion mensuelle
  Future<IntentionReflection?> upsertReflection(
      IntentionReflection reflection) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final response = await _supabase
          .from('me_intention_reflections')
          .upsert(reflection.toJson())
          .select()
          .single();

      return IntentionReflection.fromJson(response);
    } catch (e) {
      print('Error upserting reflection: $e');
      return null;
    }
  }

  /// Récupérer une réflexion pour un mois donné
  Future<IntentionReflection?> getReflection({
    required int year,
    required int month,
  }) async {
    if (_currentUserId == null) return null;

    try {
      final response = await _supabase
          .from('me_intention_reflections')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();

      if (response == null) return null;
      return IntentionReflection.fromJson(response);
    } catch (e) {
      print('Error fetching reflection: $e');
      return null;
    }
  }

  /// Récupérer toutes les réflexions
  Future<List<IntentionReflection>> getAllReflections() async {
    if (_currentUserId == null) return [];

    try {
      final response = await _supabase
          .from('me_intention_reflections')
          .select()
          .eq('user_id', _currentUserId!)
          .order('year', ascending: false)
          .order('month', ascending: false);

      return (response as List)
          .map((json) => IntentionReflection.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching reflections: $e');
      return [];
    }
  }

  // ============================================
  // STATS & INSIGHTS
  // ============================================

  /// Statistiques globales sur les intentions
  Future<Map<String, dynamic>> getIntentionsStats() async {
    if (_currentUserId == null) return {};

    try {
      final allIntentions = await _supabase
          .from('me_life_intentions')
          .select()
          .eq('user_id', _currentUserId!);

      final intentions =
      (allIntentions as List).map((json) => LifeIntention.fromJson(json));

      final active = intentions.where((i) => i.status == IntentionStatus.active).length;
      final completed = intentions.where((i) => i.status == IntentionStatus.completed).length;
      final total = intentions.length;

      return {
        'total': total,
        'active': active,
        'completed': completed,
        'completion_rate': total > 0 ? (completed / total * 100).round() : 0,
      };
    } catch (e) {
      print('Error fetching stats: $e');
      return {};
    }
  }

  /// Récupérer l'intention principale à afficher sur le dashboard
  Future<LifeIntention?> getPrimaryIntention() async {
    if (_currentUserId == null) return null;

    try {
      // Priorité : intentions trackables actives avec le moins de progrès
      final response = await _supabase
          .from('me_life_intentions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('status', 'active')
          .eq('is_trackable', true)
          .order('current_value', ascending: true)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        // Sinon, n'importe quelle intention active
        final fallback = await _supabase
            .from('me_life_intentions')
            .select()
            .eq('user_id', _currentUserId!)
            .eq('status', 'active')
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        if (fallback == null) return null;
        return LifeIntention.fromJson(fallback);
      }

      return LifeIntention.fromJson(response);
    } catch (e) {
      print('Error fetching primary intention: $e');
      return null;
    }
  }

  // ============================================
  // ARCHIVAGE AUTOMATIQUE
  // ============================================

  /// Archiver les intentions expirées (à appeler au démarrage de l'app)
  Future<void> archiveExpiredIntentions() async {
    if (_currentUserId == null) return;

    try {
      await _supabase.rpc('archive_expired_intentions');
    } catch (e) {
      print('Error archiving expired intentions: $e');
    }
  }
}
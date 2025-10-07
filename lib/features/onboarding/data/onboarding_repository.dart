// lib/features/onboarding/data/onboarding_repository.dart

import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper de résultat simple
class RepositoryResult<T> {
  final T? data;
  final String? error;
  final bool success;

  RepositoryResult.success(this.data)
      : error = null,
        success = true;
  RepositoryResult.failure(this.error)
      : data = null,
        success = false;
}

class OnboardingRepository {
  final SupabaseClient _client;
  OnboardingRepository(this._client);

  // --- Public API ---------------------------------------------------------

  /// Retourne true si l'utilisateur a complété l'onboarding.
  /// Logique compatible:
  /// 1) `onboarding_completed_at` non nul
  /// 2) ou `has_completed_onboarding` == true (legacy)
  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final row = await _client
          .from('users')
          .select('onboarding_completed_at, has_completed_onboarding')
          .eq('id', userId)
          .maybeSingle();

      if (row == null) return false; // pas de ligne profil

      final completedAt = row['onboarding_completed_at'];
      if (completedAt != null) return true;

      // compatibilité avec l'ancien bool si encore présent
      final legacy = row['has_completed_onboarding'];
      return legacy == true;
    } on PostgrestException catch (e) {
      // Ne casse pas le routage. Retourne false et log clair.
      // Exemple d'erreur précédente: colonne manquante dans le cache de schéma
      // => gérée côté SQL par `notify pgrst, 'reload schema'`.
      // Ici on reste tolérant.
      // ignore: avoid_print
      print('❌ PostgrestException hasCompletedOnboarding: ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erreur inattendue hasCompletedOnboarding: $e');
      return false;
    }
  }

  /// Marque l'onboarding comme complété.
  /// Ecrit un horodatage et maintient le bool pour compat.
  Future<void> completeOnboarding(String userId) async {
    try {
      await _ensureUserRow(userId);

      await _client
          .from('users')
          .update({
            'onboarding_completed_at': DateTime.now().toIso8601String(),
            // bool legacy pour compat avec triggers/dashboards existants
            'has_completed_onboarding': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('❌ Erreur completeOnboarding: ${e.message}');
      throw Exception("Impossible de compléter l'onboarding: ${e.message}");
    }
  }

  /// Sauvegarde le statut relationnel (solo/duo).
  Future<void> saveStatus(String userId, String status) async {
    try {
      await _ensureUserRow(userId);

      await _client
          .from('users')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('❌ Erreur saveStatus: ${e.message}');
      throw Exception('Impossible de sauvegarder le statut: ${e.message}');
    }
  }

  /// Sauvegarde les objectifs utilisateur.
  Future<void> saveGoals(String userId, List<String> objectives) async {
    try {
      await _ensureUserRow(userId);

      await _client
          .from('users')
          .update({
            'objectives': objectives,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('❌ Erreur saveGoals: ${e.message}');
      throw Exception('Impossible de sauvegarder les objectifs: ${e.message}');
    }
  }

  /// Sauvegarde le profil basique.
  Future<void> saveProfile(
    String userId,
    String firstName,
    List<String> interests,
  ) async {
    try {
      await _ensureUserRow(userId);

      await _client
          .from('users')
          .update({
            'first_name': firstName,
            'interests': interests,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('❌ Erreur saveProfile: ${e.message}');
      throw Exception('Impossible de sauvegarder le profil: ${e.message}');
    }
  }

  /// Génère un code d'invitation sécurisé et crée une relation pending.
  Future<String> generateInviteCode(String userId) async {
    try {
      final code = _generateSecureCode();
      final relationId = _generateUuid();

      await _client.from('relations').insert({
        'id': relationId,
        'user_a': userId,
        'status': 'pending',
        'invite_code': code,
        'created_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      });

      return code;
    } on PostgrestException catch (e) {
      // Collision très rare du code: réessaie automatiquement
      final msg = e.message.toLowerCase();
      if (msg.contains('duplicate') || msg.contains('unique')) {
        return generateInviteCode(userId);
      }
      // ignore: avoid_print
      print('❌ Erreur generateInviteCode: ${e.message}');
      throw Exception('Impossible de générer le code: ${e.message}');
    }
  }

  /// Rejoint une relation à partir d'un code valide.
  Future<bool> joinWithCode(String userId, String code) async {
    try {
      final now = DateTime.now().toIso8601String();

      final relation = await _client
          .from('relations')
          .select()
          .eq('invite_code', code)
          .eq('status', 'pending')
          .gte('expires_at', now)
          .maybeSingle();

      if (relation == null) return false; // code invalide/expiré
      if (relation['user_a'] == userId) return false; // auto-join interdit

      await _client
          .from('relations')
          .update({
            'user_b': userId,
            'status': 'active',
            'connected_at': DateTime.now().toIso8601String(),
          })
          .eq('id', relation['id']);

      return true;
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('❌ Erreur joinWithCode: ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erreur inattendue joinWithCode: $e');
      return false;
    }
  }

  /// Retourne un code d'invitation encore valide si existant.
  Future<String?> getExistingInviteCode(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final row = await _client
          .from('relations')
          .select('invite_code')
          .eq('user_a', userId)
          .eq('status', 'pending')
          .gte('expires_at', now)
          .maybeSingle();

      return row?['invite_code'];
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erreur getExistingInviteCode: $e');
      return null;
    }
  }

  // --- Helpers privés -----------------------------------------------------

  Future<void> _ensureUserRow(String userId) async {
    final exists = await _userExists(userId);
    if (!exists) {
      await _createUser(userId);
    }
  }

  Future<bool> _userExists(String userId) async {
    try {
      final row = await _client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      return row != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> _createUser(String userId) async {
    try {
      await _client.from('users').insert({
        'id': userId,
        'created_at': DateTime.now().toIso8601String(),
        'has_completed_onboarding': false,
      });
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erreur _createUser: $e');
      // en cas de race condition, on ignore
    }
  }

  String _generateSecureCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    final buf = StringBuffer();
    for (var i = 0; i < 6; i++) {
      buf.write(chars[rnd.nextInt(chars.length)]);
    }
    return buf.toString();
  }

  String _generateUuid() {
    final rnd = Random.secure();
    final values = List<int>.generate(16, (_) => rnd.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // version 4
    values[8] = (values[8] & 0x3f) | 0x80; // variant
    final hex = values.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}

// Riverpod provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(Supabase.instance.client);
});
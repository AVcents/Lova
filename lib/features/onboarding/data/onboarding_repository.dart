// lib/features/onboarding/data/onboarding_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingRepository {
  final SupabaseClient _client;

  OnboardingRepository(this._client);

  // Vérifier si l'onboarding est complété
  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('has_completed_onboarding')
          .eq('id', userId)
          .single();

      return response['has_completed_onboarding'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Sauvegarder le statut relationnel
  Future<void> saveStatus(String userId, String status) async {
    await _client
        .from('users')
        .update({'status': status})
        .eq('id', userId);
  }

  // Sauvegarder les objectifs
  Future<void> saveGoals(String userId, List<String> objectives) async {
    await _client
        .from('users')
        .update({'objectives': objectives})
        .eq('id', userId);
  }

  // Sauvegarder le profil
  Future<void> saveProfile(String userId, String firstName, List<String> interests) async {
    await _client
        .from('users')
        .update({
      'first_name': firstName,
      'interests': interests,
    })
        .eq('id', userId);
  }

  // Générer un code d'invitation unique
  Future<String> generateInviteCode(String userId) async {
    final code = _generateCode();

    await _client.from('relations').insert({
      'id': _generateUuid(),
      'user_a': userId,
      'status': 'pending',
      'invite_code': code,
    });

    return code;
  }

  // Rejoindre avec un code
  Future<bool> joinWithCode(String userId, String code) async {
    try {
      // Vérifier si le code existe et est en attente
      final relation = await _client
          .from('relations')
          .select()
          .eq('invite_code', code)
          .eq('status', 'pending')
          .single();

      if (relation != null) {
        // Mettre à jour la relation
        await _client
            .from('relations')
            .update({
          'user_b': userId,
          'status': 'active',
        })
            .eq('id', relation['id']);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le code d'invitation existant
  Future<String?> getExistingInviteCode(String userId) async {
    try {
      final response = await _client
          .from('relations')
          .select('invite_code')
          .eq('user_a', userId)
          .eq('status', 'pending')
          .single();

      return response['invite_code'];
    } catch (e) {
      return null;
    }
  }

  // Marquer l'onboarding comme complété
  Future<void> completeOnboarding(String userId) async {
    await _client
        .from('users')
        .update({'has_completed_onboarding': true})
        .eq('id', userId);
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i * 17) % chars.length];
    }
    return code;
  }

  String _generateUuid() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
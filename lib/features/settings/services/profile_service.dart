// lib/features/settings/services/profile_service.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider pour le service
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(Supabase.instance.client);
});

// Provider pour les données du profil
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final service = ref.read(profileServiceProvider);
  return service.getCurrentProfile();
});

// Provider pour surveiller les changements
final profileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final service = ref.read(profileServiceProvider);
  return service.profileStream();
});

class UserProfile {
  final String id;

  // Informations de base
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? prenom;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? avatarUrl;

  // Localisation
  final String? timezone;
  final String? city;
  final String? country;

  // Onboarding et relation
  final bool? hasCompletedOnboarding;
  final List<String>? objectives;
  final List<String>? interests;
  final String? relationId;

  // Préférences
  final String? preferredLanguage;
  final bool? notificationEmail;
  final bool? notificationPush;

  // Subscription
  final String? subscriptionTier;
  final DateTime? subscriptionStartedAt;
  final DateTime? subscriptionExpiresAt;

  // Analytics et engagement
  final DateTime? lastLoginAt;
  final int? loginCount;
  final int? profileCompletionPercent;

  // Consentements RGPD
  final bool? marketingConsent;
  final bool? analyticsConsent;
  final bool? dataProcessingConsent;

  // Tracking acquisition
  final String? referralSource;
  final String? referralCode;

  // Métadonnées
  final String? accountStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? onboardingCompletedAt;

  UserProfile({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.prenom,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
    this.timezone,
    this.city,
    this.country,
    this.hasCompletedOnboarding,
    this.objectives,
    this.interests,
    this.relationId,
    this.preferredLanguage,
    this.notificationEmail,
    this.notificationPush,
    this.subscriptionTier,
    this.subscriptionStartedAt,
    this.subscriptionExpiresAt,
    this.lastLoginAt,
    this.loginCount,
    this.profileCompletionPercent,
    this.marketingConsent,
    this.analyticsConsent,
    this.dataProcessingConsent,
    this.referralSource,
    this.referralCode,
    this.accountStatus,
    this.createdAt,
    this.updatedAt,
    this.onboardingCompletedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      prenom: json['prenom'] as String?,
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      timezone: json['timezone'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      hasCompletedOnboarding: json['has_completed_onboarding'] as bool?,
      objectives: (json['objectives'] as List<dynamic>?)?.cast<String>(),
      interests: (json['interests'] as List<dynamic>?)?.cast<String>(),
      relationId: json['relation_id'] as String?,
      preferredLanguage: json['preferred_language'] as String?,
      notificationEmail: json['notification_email'] as bool?,
      notificationPush: json['notification_push'] as bool?,
      subscriptionTier: json['subscription_tier'] as String?,
      subscriptionStartedAt: json['subscription_started_at'] != null
          ? DateTime.parse(json['subscription_started_at'])
          : null,
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'])
          : null,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      loginCount: json['login_count'] as int?,
      profileCompletionPercent: json['profile_completion_percent'] as int?,
      marketingConsent: json['marketing_consent'] as bool?,
      analyticsConsent: json['analytics_consent'] as bool?,
      dataProcessingConsent: json['data_processing_consent'] as bool?,
      referralSource: json['referral_source'] as String?,
      referralCode: json['referral_code'] as String?,
      accountStatus: json['account_status'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      onboardingCompletedAt: json['onboarding_completed_at'] != null
          ? DateTime.parse(json['onboarding_completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'prenom': prenom,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'avatar_url': avatarUrl,
      'timezone': timezone,
      'city': city,
      'country': country,
      'has_completed_onboarding': hasCompletedOnboarding,
      'objectives': objectives,
      'interests': interests,
      'relation_id': relationId,
      'preferred_language': preferredLanguage,
      'notification_email': notificationEmail,
      'notification_push': notificationPush,
      'subscription_tier': subscriptionTier,
      'subscription_started_at': subscriptionStartedAt?.toIso8601String(),
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'login_count': loginCount,
      'profile_completion_percent': profileCompletionPercent,
      'marketing_consent': marketingConsent,
      'analytics_consent': analyticsConsent,
      'data_processing_consent': dataProcessingConsent,
      'referral_source': referralSource,
      'referral_code': referralCode,
      'account_status': accountStatus,
    };
  }
}

class ProfileService {
  final SupabaseClient _client;

  ProfileService(this._client);

  // Récupérer le profil actuel
  Future<UserProfile?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      print('Erreur récupération profil: $e');
      return null;
    }
  }

  // Stream du profil pour écouter les changements
  Stream<UserProfile?> profileStream() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) => data.isEmpty ? null : UserProfile.fromJson(data.first));
  }

  // Mettre à jour le profil
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? prenom,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? timezone,
    String? city,
    String? country,
    List<String>? objectives,
    List<String>? interests,
    String? preferredLanguage,
    bool? notificationEmail,
    bool? notificationPush,
    bool? marketingConsent,
    bool? analyticsConsent,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final updates = <String, dynamic>{};

      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (prenom != null) updates['prenom'] = prenom;
      if (phone != null) updates['phone'] = phone;
      if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      if (gender != null) updates['gender'] = gender;
      if (timezone != null) updates['timezone'] = timezone;
      if (city != null) updates['city'] = city;
      if (country != null) updates['country'] = country;
      if (objectives != null) updates['objectives'] = objectives;
      if (interests != null) updates['interests'] = interests;
      if (preferredLanguage != null) updates['preferred_language'] = preferredLanguage;
      if (notificationEmail != null) updates['notification_email'] = notificationEmail;
      if (notificationPush != null) updates['notification_push'] = notificationPush;
      if (marketingConsent != null) updates['marketing_consent'] = marketingConsent;
      if (analyticsConsent != null) updates['analytics_consent'] = analyticsConsent;

      if (updates.isEmpty) return true;

      await _client
          .from('users')
          .update(updates)
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Erreur mise à jour profil: $e');
      return false;
    }
  }

  // Changer l'email (nécessite confirmation)
  Future<bool> changeEmail(String newEmail) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      return true;
    } catch (e) {
      print('Erreur changement email: $e');
      return false;
    }
  }

  // Changer le mot de passe
  Future<bool> changePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return true;
    } catch (e) {
      print('Erreur changement mot de passe: $e');
      return false;
    }
  }

  // Upload avatar
  Future<String?> uploadAvatar(File image) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final bytes = await image.readAsBytes();
      final ext = image.path.split('.').last;
      final path = 'users/$userId/avatar.$ext'; // Changé pour respecter la contrainte

      await _client.storage
          .from('avatars')
          .uploadBinary(path, bytes,
          fileOptions: const FileOptions(upsert: true)
      );

      final signedUrl = await _client.storage
          .from('avatars')
          .createSignedUrl(path, 3600);

      await _client
          .from('users')
          .update({'avatar_url': path})
          .eq('id', userId);

      return signedUrl;
    } catch (e) {
      print('Erreur upload avatar: $e');
      return null;
    }
  }

  // Récupérer URL signée pour un avatar
  Future<String?> getAvatarUrl(String? avatarPath) async {
    if (avatarPath == null || avatarPath.isEmpty) return null;

    try {
      if (avatarPath.startsWith('http')) return avatarPath;

      final signedUrl = await _client.storage
          .from('avatars')
          .createSignedUrl(avatarPath, 3600);

      return signedUrl;
    } catch (e) {
      print('Erreur récupération URL avatar: $e');
      return null;
    }
  }

  // Supprimer l'avatar
  Future<bool> deleteAvatar() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final profile = await getCurrentProfile();
      if (profile?.avatarUrl != null) {
        await _client.storage
            .from('avatars')
            .remove([profile!.avatarUrl!]);
      }

      await _client
          .from('users')
          .update({'avatar_url': null})
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Erreur suppression avatar: $e');
      return false;
    }
  }

  // Compléter l'onboarding
  Future<bool> completeOnboarding() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client
          .from('users')
          .update({
        'has_completed_onboarding': true,
        'onboarding_completed_at': DateTime.now().toIso8601String(),
      })
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Erreur completion onboarding: $e');
      return false;
    }
  }

  // Supprimer le compte
  Future<bool> deleteAccount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client.rpc('anonymize_user', params: {'uid': userId});
      await _client.auth.signOut();
      return true;
    } catch (e) {
      print('Erreur suppression compte: $e');
      return false;
    }
  }

  // Mettre à jour le last_login (à appeler au démarrage de l'app)
  Future<void> updateLastLogin() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _client.rpc('increment_login_count');
    } catch (e) {
      print('Erreur update last login: $e');
    }
  }
}
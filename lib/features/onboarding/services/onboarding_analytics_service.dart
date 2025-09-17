// lib/features/onboarding/services/onboarding_analytics_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider pour le service d'analytics
final onboardingAnalyticsProvider = Provider<OnboardingAnalyticsService>((ref) {
  return OnboardingAnalyticsService(Supabase.instance.client);
});

class OnboardingAnalyticsService {
  final SupabaseClient _client;
  final DateTime _sessionStartTime = DateTime.now();

  OnboardingAnalyticsService(this._client);

  // Structure pour stocker les événements localement avant envoi
  final List<OnboardingEvent> _events = [];

  // Tracker le début de l'onboarding
  Future<void> trackOnboardingStarted() async {
    await _trackEvent(OnboardingEvent(
      name: 'onboarding_started',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': _getPlatform(),
      },
    ));
  }

  // Tracker la complétion d'une étape
  Future<void> trackStepCompleted({
    required String stepName,
    required int stepNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    final duration = DateTime.now().difference(_sessionStartTime).inSeconds;

    await _trackEvent(OnboardingEvent(
      name: 'onboarding_step_completed',
      properties: {
        'step_name': stepName,
        'step_number': stepNumber,
        'time_spent_seconds': duration,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      },
    ));
  }

  // Tracker le choix du statut
  Future<void> trackStatusSelected(String status) async {
    await _trackEvent(OnboardingEvent(
      name: 'status_selected',
      properties: {
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker les objectifs sélectionnés
  Future<void> trackGoalsSelected(List<String> goals) async {
    await _trackEvent(OnboardingEvent(
      name: 'goals_selected',
      properties: {
        'goals': goals,
        'goals_count': goals.length,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker les intérêts sélectionnés
  Future<void> trackInterestsSelected(List<String> interests) async {
    await _trackEvent(OnboardingEvent(
      name: 'interests_selected',
      properties: {
        'interests': interests,
        'interests_count': interests.length,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker la génération d'un code d'invitation
  Future<void> trackInviteCodeGenerated(String code) async {
    await _trackEvent(OnboardingEvent(
      name: 'invite_code_generated',
      properties: {
        'code_length': code.length,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker l'utilisation d'un code d'invitation
  Future<void> trackInviteCodeUsed({
    required bool success,
    String? errorReason,
  }) async {
    await _trackEvent(OnboardingEvent(
      name: 'invite_code_used',
      properties: {
        'success': success,
        'error_reason': errorReason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker le skip de l'invitation
  Future<void> trackInviteSkipped() async {
    await _trackEvent(OnboardingEvent(
      name: 'invite_skipped',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Tracker la complétion de l'onboarding
  Future<void> trackOnboardingCompleted({
    required String status,
    required List<String> goals,
    required List<String> interests,
    required bool hasPartner,
  }) async {
    final totalDuration = DateTime.now().difference(_sessionStartTime);

    await _trackEvent(OnboardingEvent(
      name: 'onboarding_completed',
      properties: {
        'status': status,
        'goals_count': goals.length,
        'interests_count': interests.length,
        'has_partner': hasPartner,
        'total_duration_seconds': totalDuration.inSeconds,
        'total_duration_readable': _formatDuration(totalDuration),
        'timestamp': DateTime.now().toIso8601String(),
        'platform': _getPlatform(),
      },
    ));

    // Envoyer tous les événements en batch
    await _sendBatchEvents();
  }

  // Tracker l'abandon de l'onboarding
  Future<void> trackOnboardingAbandoned({
    required String lastStep,
    required int stepNumber,
  }) async {
    final duration = DateTime.now().difference(_sessionStartTime);

    await _trackEvent(OnboardingEvent(
      name: 'onboarding_abandoned',
      properties: {
        'last_step': lastStep,
        'step_number': stepNumber,
        'duration_seconds': duration.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));

    // Envoyer immédiatement
    await _sendBatchEvents();
  }

  // Tracker les erreurs
  Future<void> trackError({
    required String step,
    required String error,
    String? details,
  }) async {
    await _trackEvent(OnboardingEvent(
      name: 'onboarding_error',
      properties: {
        'step': step,
        'error': error,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  // Méthode privée pour enregistrer un événement
  Future<void> _trackEvent(OnboardingEvent event) async {
    _events.add(event);

    // Envoyer immédiatement les événements critiques
    if (_isCriticalEvent(event.name)) {
      await _sendEvent(event);
    }

    // Log en développement
    _logEvent(event);
  }

  // Envoyer un événement unique
  Future<void> _sendEvent(OnboardingEvent event) async {
    try {
      await _client.from('analytics_events').insert({
        'user_id': _client.auth.currentUser?.id,
        'event_name': event.name,
        'properties': event.properties,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // En cas d'erreur, stocker localement ou logger
      print('Analytics error: $e');
    }
  }

  // Envoyer tous les événements en batch
  Future<void> _sendBatchEvents() async {
    if (_events.isEmpty) return;

    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final batch = _events.map((event) => {
        'user_id': userId,
        'event_name': event.name,
        'properties': event.properties,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      await _client.from('analytics_events').insert(batch);

      // Vider la liste après envoi réussi
      _events.clear();
    } catch (e) {
      print('Batch analytics error: $e');
    }
  }

  // Déterminer si un événement est critique
  bool _isCriticalEvent(String eventName) {
    return [
      'onboarding_completed',
      'onboarding_abandoned',
      'onboarding_error',
    ].contains(eventName);
  }

  // Logger l'événement en développement
  void _logEvent(OnboardingEvent event) {
    const bool isDebug = true; // À remplacer par kDebugMode
    if (isDebug) {
      print('📊 Analytics: ${event.name}');
      event.properties.forEach((key, value) {
        print('   $key: $value');
      });
    }
  }

  // Obtenir la plateforme
  String _getPlatform() {
    // À implémenter selon vos besoins
    return 'web'; // ou 'ios', 'android'
  }

  // Formater la durée
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  // Calculer les métriques de l'onboarding
  Future<OnboardingMetrics> getOnboardingMetrics() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return OnboardingMetrics.empty();

      // Récupérer les événements de l'utilisateur
      final response = await _client
          .from('analytics_events')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return OnboardingMetrics.fromEvents(response as List);
    } catch (e) {
      return OnboardingMetrics.empty();
    }
  }
}

// Classe pour représenter un événement
class OnboardingEvent {
  final String name;
  final Map<String, dynamic> properties;

  OnboardingEvent({
    required this.name,
    required this.properties,
  });
}

// Classe pour les métriques
class OnboardingMetrics {
  final int totalStepsCompleted;
  final Duration totalTime;
  final bool isCompleted;
  final String? lastStep;
  final DateTime? completedAt;

  OnboardingMetrics({
    required this.totalStepsCompleted,
    required this.totalTime,
    required this.isCompleted,
    this.lastStep,
    this.completedAt,
  });

  factory OnboardingMetrics.empty() {
    return OnboardingMetrics(
      totalStepsCompleted: 0,
      totalTime: Duration.zero,
      isCompleted: false,
    );
  }

  factory OnboardingMetrics.fromEvents(List<dynamic> events) {
    // Parser les événements pour extraire les métriques
    int stepsCompleted = 0;
    bool completed = false;
    String? lastStep;
    DateTime? completedAt;
    Duration totalTime = Duration.zero;

    for (final event in events) {
      if (event['event_name'] == 'onboarding_step_completed') {
        stepsCompleted++;
        lastStep = event['properties']['step_name'];
      } else if (event['event_name'] == 'onboarding_completed') {
        completed = true;
        completedAt = DateTime.parse(event['created_at']);
        totalTime = Duration(
          seconds: event['properties']['total_duration_seconds'] ?? 0,
        );
      }
    }

    return OnboardingMetrics(
      totalStepsCompleted: stepsCompleted,
      totalTime: totalTime,
      isCompleted: completed,
      lastStep: lastStep,
      completedAt: completedAt,
    );
  }
}
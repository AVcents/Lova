import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/onboarding/data/onboarding_repository.dart';

// État synchrone pour l'onboarding
final onboardingStateProvider = StateProvider.autoDispose<bool>((ref) => false);

// Service d'initialisation
class OnboardingStateService {
  static Future<void> initialize(WidgetRef ref) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final repo = ref.read(onboardingRepositoryProvider);
      final hasCompleted = await repo.hasCompletedOnboarding(userId);

      // Mettre à jour l'état synchrone
      ref.read(onboardingStateProvider.notifier).state = hasCompleted;
    } catch (e) {
      print('Erreur init onboarding: $e');
    }
  }
}
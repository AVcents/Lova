// lib/features/onboarding/providers/onboarding_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/onboarding_repository.dart';

// === Onboarding flag synchrone (pour router sans async) ===
final onboardingStateProvider = StateProvider<bool>((ref) => false);

class OnboardingStateService {
  static Future<void> initialize(WidgetRef ref) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final repo = ref.read(onboardingRepositoryProvider);
      final hasCompleted = await repo.hasCompletedOnboarding(userId);
      ref.read(onboardingStateProvider.notifier).state = hasCompleted;
    } catch (e) {
      // ignore: avoid_print
      print('Erreur init onboarding: $e');
    }
  }
}

// Provider pour le repository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(Supabase.instance.client);
});

// Provider pour vérifier si l'onboarding est complété
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(onboardingRepositoryProvider);
  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) return false;

  return await repo.hasCompletedOnboarding(userId);
});

// State pour l'onboarding
class OnboardingState {
  final int currentStep;
  final String? status;
  final List<String> selectedGoals;
  final String? firstName;
  final List<String> selectedInterests;
  final String? inviteCode;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentStep = 0,
    this.status,
    this.selectedGoals = const [],
    this.firstName,
    this.selectedInterests = const [],
    this.inviteCode,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentStep,
    String? status,
    List<String>? selectedGoals,
    String? firstName,
    List<String>? selectedInterests,
    String? inviteCode,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      firstName: firstName ?? this.firstName,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      inviteCode: inviteCode ?? this.inviteCode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Controller StateNotifier
class OnboardingController extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;
  final Ref ref;

  OnboardingController(this._repository, this.ref) : super(const OnboardingState());

  String? get _userId => Supabase.instance.client.auth.currentUser?.id;

  // Navigation entre les étapes
  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  // Sauvegarder le statut
  Future<void> saveStatus(String status) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.saveStatus(_userId!, status);
      state = state.copyWith(
        status: status,
        isLoading: false,
      );
      nextStep();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la sauvegarde du statut',
      );
    }
  }

  // Gérer la sélection des objectifs
  void toggleGoal(String goal) {
    final goals = List<String>.from(state.selectedGoals);
    if (goals.contains(goal)) {
      goals.remove(goal);
    } else {
      goals.add(goal);
    }
    state = state.copyWith(selectedGoals: goals);
  }

  Future<void> saveGoals() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.saveGoals(_userId!, state.selectedGoals);
      state = state.copyWith(isLoading: false);
      nextStep();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la sauvegarde des objectifs',
      );
    }
  }

  // Gérer le profil
  void updateFirstName(String name) {
    state = state.copyWith(firstName: name);
  }

  void toggleInterest(String interest) {
    final interests = List<String>.from(state.selectedInterests);
    if (interests.contains(interest)) {
      interests.remove(interest);
    } else {
      interests.add(interest);
    }
    state = state.copyWith(selectedInterests: interests);
  }

  Future<void> saveProfile() async {
    if (state.firstName == null || state.firstName!.isEmpty) {
      state = state.copyWith(error: 'Le prénom est obligatoire');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.saveProfile(
        _userId!,
        state.firstName!,
        state.selectedInterests,
      );
      state = state.copyWith(isLoading: false);

      // Si célibataire, terminer l'onboarding
      if (state.status == 'solo') {
        await completeOnboarding();
      } else {
        nextStep();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la sauvegarde du profil',
      );
    }
  }

  // Gérer l'invitation
  Future<void> generateInviteCode() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Vérifier d'abord s'il existe déjà un code
      String? existingCode = await _repository.getExistingInviteCode(_userId!);

      if (existingCode != null) {
        state = state.copyWith(
          inviteCode: existingCode,
          isLoading: false,
        );
      } else {
        final code = await _repository.generateInviteCode(_userId!);
        state = state.copyWith(
          inviteCode: code,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la génération du code',
      );
    }
  }

  Future<void> joinWithCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _repository.joinWithCode(_userId!, code);

      if (success) {
        await completeOnboarding();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Code invalide ou expiré',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la connexion',
      );
    }
  }

  // Terminer l'onboarding
  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding(_userId!);
    ref.read(onboardingStateProvider.notifier).state = true;

    // Afficher le dialog de complétion
    state = state.copyWith(
      isLoading: false,
      currentStep: -1, // Indicateur spécial pour la complétion
    );
  }

  // Skip l'invitation (pour tester seul)
  Future<void> skipInvite() async {
    await completeOnboarding();
  }
}

// Provider principal
final onboardingControllerProvider =
StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final repository = ref.read(onboardingRepositoryProvider);
  return OnboardingController(repository, ref);
});
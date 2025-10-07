// lib/features/onboarding/providers/onboarding_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/onboarding_repository.dart';

// === Provider unique pour l'état synchrone de l'onboarding ===
// Ce provider est utilisé par le router pour les redirections
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

/// Service d'initialisation sans `static`, scope par Provider
class OnboardingInitService {
  final Ref ref;
  bool _isInitializing = false;
  bool _hasInitialized = false;
  String? _lastUid;

  OnboardingInitService(this.ref);

  Future<void> initialize() async {
    if (_isInitializing) return;
    _isInitializing = true;

    final userId = Supabase.instance.client.auth.currentUser?.id;

    // Pas d'utilisateur -> purge état visible et flags
    if (userId == null) {
      try {
        ref.read(onboardingCompletedProvider.notifier).state = false;
      } catch (_) {}
      _hasInitialized = false;
      _lastUid = null;
      _isInitializing = false;
      return;
    }

    // Si l'UID a changé, purge l'état UI et force ré-init
    final uidChanged = _lastUid != null && _lastUid != userId;
    if (uidChanged) {
      try {
        ref.read(onboardingControllerProvider.notifier).resetForm();
        ref.read(onboardingCompletedProvider.notifier).state = false;
      } catch (_) {}
      _hasInitialized = false;
    }

    // Si déjà init pour ce même UID, rien à faire
    if (_hasInitialized && _lastUid == userId) {
      _isInitializing = false;
      return;
    }

    try {
      final repo = ref.read(onboardingRepositoryProvider);
      final hasCompleted = await repo.hasCompletedOnboarding(userId);
      ref.read(onboardingCompletedProvider.notifier).state = hasCompleted;
      _hasInitialized = true;
      _lastUid = userId;
    } catch (e) {
      ref.read(onboardingCompletedProvider.notifier).state = false;
      _hasInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  void reset() {
    _hasInitialized = false;
    _isInitializing = false;
    _lastUid = null;
  }
}

/// Provider pour accéder au service (une instance par ProviderScope)
final onboardingInitServiceProvider = Provider<OnboardingInitService>((ref) {
  return OnboardingInitService(ref);
});

/// Helpers non-statiques pour faciliter l'appel dans le code existant
Future<void> initializeOnboarding(WidgetRef ref) =>
    ref.read(onboardingInitServiceProvider).initialize();
void resetOnboarding(WidgetRef ref) =>
    ref.read(onboardingInitServiceProvider).reset();

// Provider asynchrone pour vérifier si l'onboarding est complété
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(onboardingRepositoryProvider);
  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) return false;

  try {
    final hasCompleted = await repo.hasCompletedOnboarding(userId);
    // Synchroniser avec le provider synchrone
    ref.read(onboardingCompletedProvider.notifier).state = hasCompleted;
    return hasCompleted;
  } catch (e) {
    print('❌ Erreur vérification onboarding: $e');
    return false;
  }
});

// État pour l'onboarding
class OnboardingState {
  final int currentStep;
  final String? status;
  final List<String> selectedGoals;
  final String? firstName;
  final List<String> selectedInterests;
  final String? inviteCode;
  final bool isLoading;
  final String? error;
  final String? errorCode; // Ajout pour meilleure gestion d'erreur

  const OnboardingState({
    this.currentStep = 0,
    this.status,
    this.selectedGoals = const [],
    this.firstName,
    this.selectedInterests = const [],
    this.inviteCode,
    this.isLoading = false,
    this.error,
    this.errorCode,
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
    String? errorCode,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      firstName: firstName ?? this.firstName,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      inviteCode: inviteCode ?? this.inviteCode,
      isLoading: isLoading ?? this.isLoading,
      error: error,  // Permettre de réinitialiser à null
      errorCode: errorCode, // Permettre de réinitialiser à null
    );
  }
}

// Controller StateNotifier amélioré
class OnboardingController extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;
  final Ref ref;

  OnboardingController(this._repository, this.ref) : super(const OnboardingState());

  void resetForm() {
    state = const OnboardingState();
  }

  String? get _userId => Supabase.instance.client.auth.currentUser?.id;

  // Navigation entre les étapes
  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        error: null, // Clear errors on navigation
        errorCode: null,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        error: null,
        errorCode: null,
      );
    }
  }

  void goToStep(int step) {
    state = state.copyWith(
      currentStep: step,
      error: null,
      errorCode: null,
    );
  }

  // Sauvegarder le statut avec meilleure gestion d'erreur
  Future<void> saveStatus(String status) async {
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, errorCode: null);

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
        error: _getErrorMessage(e),
        errorCode: 'save_status_error',
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
    if (state.selectedGoals.isEmpty) {
      state = state.copyWith(
        error: 'Veuillez sélectionner au moins un objectif',
        errorCode: 'no_goals',
      );
      return;
    }
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, errorCode: null);

    try {
      await _repository.saveGoals(_userId!, state.selectedGoals);
      state = state.copyWith(isLoading: false);
      nextStep();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
        errorCode: 'save_goals_error',
      );
    }
  }

  // Gérer le profil
  void updateFirstName(String name) {
    state = state.copyWith(firstName: name.trim());
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
    // Validation améliorée
    final name = state.firstName?.trim();
    if (name == null || name.isEmpty) {
      state = state.copyWith(
        error: 'Le prénom est obligatoire',
        errorCode: 'name_required',
      );
      return;
    }

    if (name.length < 2) {
      state = state.copyWith(
        error: 'Le prénom doit contenir au moins 2 caractères',
        errorCode: 'name_too_short',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, errorCode: null);

    try {
      await _repository.saveProfile(
        _userId!,
        name,
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
        error: _getErrorMessage(e),
        errorCode: 'save_profile_error',
      );
    }
  }

  // Gérer l'invitation avec code sécurisé
  Future<void> generateInviteCode() async {
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, errorCode: null);

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
        error: _getErrorMessage(e),
        errorCode: 'generate_code_error',
      );
    }
  }

  Future<void> joinWithCode(String code) async {
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }

    final cleanCode = code.trim().toUpperCase();

    if (cleanCode.length != 6) {
      state = state.copyWith(
        error: 'Le code doit contenir 6 caractères',
        errorCode: 'invalid_code_length',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null, errorCode: null);

    try {
      final success = await _repository.joinWithCode(_userId!, cleanCode);

      if (success) {
        await completeOnboarding();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Code invalide ou expiré',
          errorCode: 'invalid_code',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
        errorCode: 'join_code_error',
      );
    }
  }

  // Terminer l'onboarding
  Future<void> completeOnboarding() async {
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }
    try {
      await _repository.completeOnboarding(_userId!);

      // Mise à jour du provider synchrone
      ref.read(onboardingCompletedProvider.notifier).state = true;

      // Afficher le dialog de complétion
      state = state.copyWith(
        isLoading: false,
        currentStep: -1, // Indicateur spécial pour la complétion
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
        errorCode: 'complete_error',
      );
    }
  }

  // Skip l'invitation (pour tester seul)
  Future<void> skipInvite() async {
    if (_userId == null) {
      state = state.copyWith(
        error: 'Utilisateur non connecté',
        errorCode: 'no_user',
      );
      return;
    }
    await completeOnboarding();
  }

  // Helper pour extraire un message d'erreur lisible
  String _getErrorMessage(dynamic error) {
    if (error is PostgrestException) {
      return error.message;
    } else if (error is AuthException) {
      return error.message;
    } else {
      return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
}

// Provider principal
final onboardingControllerProvider =
StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final repository = ref.read(onboardingRepositoryProvider);
  return OnboardingController(repository, ref);
});
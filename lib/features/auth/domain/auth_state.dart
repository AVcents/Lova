import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.freezed.dart';

/// AuthState minimaliste. Consommer via `maybeWhen/when` côté UI.
/// Ne pas exposer de getters (isLoading, etc.) ici.
@freezed
class AuthState with _$AuthState {
  /// Utilisateur non authentifié, aucune action en cours
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Connexion en cours
  const factory AuthState.signingIn() = _SigningIn;

  /// Inscription en cours
  const factory AuthState.signingUp() = _SigningUp;

  /// Inscription envoyée, en attente de confirmation par email (deep link)
  const factory AuthState.emailPending({
    required String email,
    String? message,
  }) = _EmailPending;

  /// Utilisateur authentifié
  const factory AuthState.authenticated({required User user}) = _Authenticated;

  /// Erreur d'authentification
  const factory AuthState.error({required String message, String? code}) =
      _Error;
}

/// Erreurs typées mappées depuis Supabase (mapping effectué dans le Notifier)
enum AuthErrorType {
  // Inscription
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,

  // Connexion
  userNotFound,
  wrongPassword,
  tooManyAttempts,
  accountDisabled,
  emailNotVerified,

  // Vérification
  expiredLink,
  invalidToken,
  alreadyVerified,

  // Réseau / divers
  networkError,
  serverError,
  unknown,
}

/// Helpers dérivés pour l'UI. N'altère pas le contrat de la machine à états.
extension AuthStateX on AuthState {
  /// True si une action de connexion/inscription est en cours
  bool get isBusy => maybeWhen(
    signingIn: () => true,
    signingUp: () => true,
    orElse: () => false,
  );

  /// Raccourci pour récupérer l'utilisateur courant ou null
  User? get userOrNull =>
      maybeWhen(authenticated: (u) => u, orElse: () => null);
}

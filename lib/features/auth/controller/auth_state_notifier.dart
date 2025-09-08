import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/features/auth/data/auth_providers.dart';
import 'package:lova/features/auth/domain/auth_repository.dart';
import 'package:lova/features/auth/domain/auth_state.dart';

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      final repo = ref.read(authRepositoryProvider);
      return AuthStateNotifier(repo);
    });

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  StreamSubscription<dynamic>? _authSub;
  Timer? _resendEmailTimer;

  AuthStateNotifier(this._repo) : super(const AuthState.unauthenticated()) {
    _initialize();
  }

  // ---- Lifecycle ----
  void _initialize() {
    // État initial basé sur l'utilisateur courant
    final current = _repo.currentUser();
    if (current != null) {
      state = AuthState.authenticated(user: current);
    }
    // Écoute des changements d'authentification
    _authSub = _repo.authStateChanges().listen((user) {
      if (user == null) {
        state = const AuthState.unauthenticated();
      } else {
        state = AuthState.authenticated(user: user);
      }
    });
  }

  // ---- Actions publiques ----
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    state = const AuthState.signingUp();
    final res = await _repo.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
    );

    if (res.success) {
      final user = _repo.currentUser();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = AuthState.emailPending(
          email: email,
          message: 'Vérifie ton email pour continuer',
        );
        _startResendTimer();
      }
    } else {
      state = AuthState.error(
        message: res.message ?? 'Erreur inconnue',
        code: res.errorType?.name,
      );
    }
    return res;
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.signingIn();
    final res = await _repo.signIn(email: email, password: password);
    if (res.success) {
      final user = _repo.currentUser();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.error(
          message: 'Connexion réussie mais utilisateur introuvable',
          code: 'no_user',
        );
      }
    } else {
      state = AuthState.error(
        message: res.message ?? 'Connexion échouée',
        code: res.errorType?.name,
      );
    }
    return res;
  }

  Future<AuthResult> signOut() async {
    await _repo.signOut();
    state = const AuthState.unauthenticated();
    return AuthResult(success: true, message: 'Déconnecté');
  }

  Future<void> resendVerificationEmail(String email, {String? emailRedirectTo}) async {
    await _repo.resendConfirmationEmail(email, emailRedirectTo: emailRedirectTo);
  }

  // ---- Resend email timer ----
  void _startResendTimer() {
    _resendEmailTimer?.cancel();
    _resendEmailTimer = Timer(const Duration(seconds: 60), () {});
  }

  bool get canResendEmail => _resendEmailTimer?.isActive != true;

  @override
  void dispose() {
    _authSub?.cancel();
    _resendEmailTimer?.cancel();
    super.dispose();
  }
}

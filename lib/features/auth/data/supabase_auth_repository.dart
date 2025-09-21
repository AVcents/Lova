import 'package:lova/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  (AuthErrorType, String) _mapAuthException(AuthException e) {
    final raw = (e.message ?? '').toLowerCase();
    final code = e.statusCode?.toString();

    if (code == '429' || raw.contains('too many') || raw.contains('rate limit')) {
      return (AuthErrorType.tooManyAttempts, 'Trop de tentatives, réessayez plus tard');
    }
    if (raw.contains('already registered') || raw.contains('already exists')) {
      return (AuthErrorType.emailAlreadyInUse, 'Cet email est déjà utilisé');
    }
    if (raw.contains('email not confirmed') || raw.contains('not confirmed') || raw.contains('confirm your email')) {
      return (AuthErrorType.emailNotVerified, 'Veuillez confirmer votre email');
    }
    if (raw.contains('invalid login') || raw.contains('invalid credentials') || raw.contains('wrong') && raw.contains('password')) {
      return (AuthErrorType.wrongPassword, 'Email ou mot de passe incorrect');
    }
    if (raw.contains('expired') || raw.contains('otp_expired') || raw.contains('token has expired')) {
      return (AuthErrorType.expiredLink, 'Le lien a expiré. Demandez-en un nouveau.');
    }
    if (raw.contains('network') || raw.contains('timeout') || raw.contains('socket')) {
      return (AuthErrorType.networkError, 'Problème réseau. Réessayez.');
    }
    return (AuthErrorType.unknown, e.message ?? 'Erreur inconnue');
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: emailRedirectTo ?? 'loova://login-callback',
      );

      // Session peut être null si confirmation email requise
      final user = response.user;
      final msg = user == null
          ? 'Confirmation email envoyée'
          : 'Inscription réussie';
      return AuthResult(success: true, message: msg, data: user);
    } on AuthException catch (e) {
      final (mappedType, mappedMsg) = _mapAuthException(e);
      return AuthResult(success: false, errorType: mappedType, message: mappedMsg);
    } catch (e) {
      return AuthResult(success: false, errorType: AuthErrorType.unknown, message: e.toString());
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return AuthResult(
          success: false,
          message: 'Email ou mot de passe incorrect',
        );
      }
      return AuthResult(
        success: true,
        message: 'Connexion réussie',
        data: user,
      );
    } on AuthException catch (e) {
      final (mappedType, mappedMsg) = _mapAuthException(e);
      return AuthResult(success: false, errorType: mappedType, message: mappedMsg);
    } catch (e) {
      return AuthResult(success: false, errorType: AuthErrorType.unknown, message: e.toString());
    }
  }

  @override
  Future<AuthResult> signInWithOtp({
    required String email,
    required OtpType type,
    String? emailRedirectTo,
  }) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: emailRedirectTo ?? 'loova://login-callback',
      );
      return AuthResult(success: true, message: 'Lien de connexion envoyé par email');
    } on AuthException catch (e) {
      final (mappedType, mappedMsg) = _mapAuthException(e);
      return AuthResult(success: false, errorType: mappedType, message: mappedMsg);
    } catch (e) {
      return AuthResult(success: false, errorType: AuthErrorType.unknown, message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  @override
  User? currentUser() {
    return _client.auth.currentUser;
  }

  @override
  Future<void> resendConfirmationEmail(
    String email, {
    String? emailRedirectTo,
  }) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: emailRedirectTo,
    );
  }

  @override
  Future<void> resetPassword(String email, {String? emailRedirectTo}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: emailRedirectTo ?? 'loova://reset-password',
    );
  }
}

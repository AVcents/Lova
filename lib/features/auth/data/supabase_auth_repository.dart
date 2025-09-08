import 'package:lova/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

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
        emailRedirectTo: emailRedirectTo,
      );

      // Session peut être null si confirmation email requise
      final user = response.user;
      final msg = user == null
          ? 'Confirmation email envoyée'
          : 'Inscription réussie';
      return AuthResult(success: true, message: msg, data: user);
    } catch (e) {
      return AuthResult(success: false, message: e.toString());
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
    } catch (e) {
      return AuthResult(success: false, message: e.toString());
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
      redirectTo: emailRedirectTo,
    );
  }
}

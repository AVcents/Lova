import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Future<AuthResponse> signUp(String email, String password, {String? emailRedirectTo}) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
    );

    // Ne pas lever d'erreur si la session est null (confirmation email requise)
    // Retourner la réponse pour que le contrôleur puisse décider
    return response;
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Connexion échouée : email ou mot de passe incorrect');
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

  Future<void> resendConfirmationEmail(String email, {String? emailRedirectTo}) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: emailRedirectTo,
    );
  }

  Future<void> resetPassword(String email, {String? emailRedirectTo}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: emailRedirectTo,
    );
  }
}


import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Future<void> signUp(String email, String password) async {
    final response = await _client.auth.signUp(email: email, password: password);

    if (response.user == null) {
      throw Exception('Inscription échouée : ${response.session?.toJson()}');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);

    if (response.user == null) {
      throw Exception('Connexion échouée : ${response.session?.toJson()}');
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
}
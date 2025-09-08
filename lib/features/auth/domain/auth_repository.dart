import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/features/auth/domain/auth_state.dart';

// Re-export for UI consumption when needed
export 'auth_state.dart' show AuthErrorType;

class AuthResult {
  final bool success;
  final AuthErrorType? errorType;
  final String? message;
  final dynamic data;

  AuthResult({required this.success, this.errorType, this.message, this.data});
}

abstract class AuthRepository {
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  });

  Future<AuthResult> signIn({required String email, required String password});

  Future<void> signOut();

  Stream<User?> authStateChanges();

  // Lecture synchrone de l'utilisateur courant
  User? currentUser();

  // Facultatif selon l'UI. Conserver ces signatures si déjà utilisées.
  Future<void> resendConfirmationEmail(String email, {String? emailRedirectTo});

  Future<void> resetPassword(String email, {String? emailRedirectTo});
}

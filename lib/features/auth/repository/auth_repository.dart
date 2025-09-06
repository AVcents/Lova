import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> signUp(String email, String password, {String? emailRedirectTo});
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<void> resendConfirmationEmail(String email, {String? emailRedirectTo});
  Future<void> resetPassword(String email, {String? emailRedirectTo});
}
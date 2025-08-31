abstract class AuthRepository {
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Stream<dynamic> authStateChanges(); // Utilisateur Supabase (User?) en sortie
}

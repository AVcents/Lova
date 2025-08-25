class AuthRepository {
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simule une requête
    if (email != 'test@test.com' || password != '123456') {
      throw Exception('Email ou mot de passe incorrect');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simule une requête
    if (email == 'existe@test.com') {
      throw Exception('Cet email est déjà utilisé');
    }
  }
}
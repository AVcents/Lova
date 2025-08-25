import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';

// Ce provider instancie le repository mocké
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Ce provider expose la logique d'auth via un controller
final authControllerProvider = Provider<AuthController>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

class AuthController {
  final AuthRepository _repo;

  AuthController(this._repo);

  Future<void> signIn(String email, String password) async {
    await _repo.signIn(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _repo.signUp(email: email, password: password);
  }
}
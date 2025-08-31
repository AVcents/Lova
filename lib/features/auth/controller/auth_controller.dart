import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';

// Provider du client Supabase
final supabaseClientProvider = riverpod.Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider du repository réel
final authRepositoryProvider = riverpod.Provider<AuthRepository>((ref) {
  final client = ref.read(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});

// Provider du contrôleur d'authentification
final authControllerProvider =
    riverpod.StateNotifierProvider<AuthController, riverpod.AsyncValue<void>>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

class AuthController extends riverpod.StateNotifier<riverpod.AsyncValue<void>> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const riverpod.AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const riverpod.AsyncLoading();
    try {
      await _repo.signIn(email, password);
      state = const riverpod.AsyncData(null);
    } catch (e, st) {
      print("❌ Erreur lors de la connexion : $e");
      state = riverpod.AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password, {required String prenom}) async {
    state = const riverpod.AsyncLoading();
    try {
      await _repo.signUp(email, password);
      await createUserProfile(email: email, prenom: prenom);
      state = const riverpod.AsyncData(null);
    } catch (e, st) {
      print("❌ Erreur lors de l'inscription : $e");
      state = riverpod.AsyncError(e, st);
    }
  }

  Future<void> createUserProfile({required String email, required String prenom}) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utilisateur non connecté");

      await Supabase.instance.client.from('users').insert({
        'id': userId,
        'email': email,
        'prenom': prenom,
        'timezone': DateTime.now().timeZoneName,
      });
    } catch (e) {
      print("❌ Erreur lors de la création du profil utilisateur : $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (e) {
      print("❌ Erreur lors de la déconnexion : $e");
      // Log ou gestion d'erreur si besoin
    }
  }
}

// Provider exposant l'utilisateur courant dans toute l'app
final currentUserProvider = riverpod.StreamProvider<User?>((ref) {
  final auth = Supabase.instance.client.auth;
  return auth.onAuthStateChange.map((event) => event.session?.user);
});
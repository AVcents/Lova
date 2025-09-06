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
  return AuthController(repo, ref);
});

// ---- Résultats typés pour le signUp ----
enum SignUpError { userAlreadyExists, emailNotConfirmed, weakPassword, unknown }

class SignUpResponse {
  final bool success; // true si inscription acceptée par Supabase
  final bool needsEmailConfirmation; // true si session == null → attendre clic email
  final SignUpError? error; // null si success
  final String? message; // message lisible UI

  const SignUpResponse({
    required this.success,
    required this.needsEmailConfirmation,
    this.error,
    this.message,
  });
}

class AuthController extends riverpod.StateNotifier<riverpod.AsyncValue<void>> {
  final AuthRepository _repo;
  final riverpod.Ref _ref;

  AuthController(this._repo, this._ref) : super(const riverpod.AsyncData(null)) {
    // Écouter les changements d'état d'auth pour gérer la confirmation email
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        // L'utilisateur vient de confirmer son email et est connecté
        try {
          // Vérifier si le profil existe
          final userId = session.user.id;
          final existingProfile = await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', userId)
              .maybeSingle();

          // Créer le profil s'il n'existe pas
          if (existingProfile == null) {
            await createUserProfile(
              email: session.user.email ?? '',
              prenom: session.user.userMetadata?['prenom'] ?? 'Utilisateur',
            );
          }

          // Notification de succès (sera gérée par l'UI)
          state = const riverpod.AsyncData(null);
        } catch (e) {
          print("❌ Erreur lors de la création du profil après signedIn : $e");
        }
      }
    });
  }

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

  Future<SignUpResponse> signUp(String email, String password, {required String prenom}) async {
    state = const riverpod.AsyncLoading();
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutter://login-callback',
        data: {'prenom': prenom},
      );

      state = const riverpod.AsyncData(null);

      // Succès côté API. Savoir si on doit afficher VerifyEmailPage ou pas.
      final needsEmail = response.session == null;
      return SignUpResponse(
        success: true,
        needsEmailConfirmation: needsEmail,
        error: null,
        message: needsEmail
            ? 'Un email de confirmation vient de t\'être envoyé.'
            : 'Inscription réussie.',
      );
    } catch (e, st) {
      // Normaliser les erreurs Supabase pour le formulaire
      String? code;
      String? msg;
      if (e is AuthException) {
        code = e.statusCode?.toString(); // parfois code HTTP
        msg = e.message;
      } else if (e is AuthApiException) {
        code = e.code; // ex: user_already_exists, email_not_confirmed
        msg = e.message;
      } else {
        msg = e.toString();
      }

      // Mapping minimal des codes connus
      SignUpError mapped;
      switch (code) {
        case 'user_already_exists':
          mapped = SignUpError.userAlreadyExists;
          msg = msg ?? 'Un compte existe déjà avec cet email.';
          break;
        case 'email_not_confirmed':
          mapped = SignUpError.emailNotConfirmed;
          msg = msg ?? 'Email non confirmé.';
          break;
        case 'weak_password':
          mapped = SignUpError.weakPassword;
          msg = msg ?? 'Mot de passe trop faible.';
          break;
        default:
          mapped = SignUpError.unknown;
          msg = msg ?? 'Erreur inconnue.';
      }

      print("❌ Erreur lors de l'inscription : $e");
      state = riverpod.AsyncError(e, st);

      return SignUpResponse(
        success: false,
        needsEmailConfirmation: false,
        error: mapped,
        message: msg,
      );
    }
  }

  Future<void> createUserProfile({required String email, required String prenom}) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("Utilisateur non connecté");

      // Insertion idempotente avec ON CONFLICT DO NOTHING
      await Supabase.instance.client.from('users').upsert({
        'id': userId,
        'email': email,
        'prenom': prenom,
        'timezone': DateTime.now().timeZoneName,
      }, onConflict: 'id');
    } catch (e) {
      print("❌ Erreur lors de la création du profil utilisateur : $e");
      rethrow;
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      print("❌ Erreur lors du renvoi de l'email de confirmation : $e");
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback',
      );
    } catch (e) {
      print("❌ Erreur lors de l'envoi du reset password : $e");
      rethrow;
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

// Provider pour écouter les événements d'authentification
final authStateChangesProvider = riverpod.StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});
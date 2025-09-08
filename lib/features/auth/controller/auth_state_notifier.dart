import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../domain/auth_state.dart';

class AuthResponse {
  final bool success;
  final AuthErrorType? errorType;
  final String? message;
  final dynamic data;

  const AuthResponse({
    required this.success,
    this.errorType,
    this.message,
    this.data,
  });

  factory AuthResponse.success([dynamic data]) => AuthResponse(
        success: true,
        data: data,
      );

  factory AuthResponse.failure(AuthErrorType type, String message) => AuthResponse(
        success: false,
        errorType: type,
        message: message,
      );
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final supa.SupabaseClient _supabase = supa.Supabase.instance.client;
  StreamSubscription<supa.AuthState>? _authSub;
  Timer? _resendEmailTimer;
  int _loginAttempts = 0;
  DateTime? _lastAttemptTime;

  AuthStateNotifier() : super(const AuthState.unauthenticated()) {
    _initialize();
  }

  // ---- Lifecycle ----
  void _initialize() {
    // Écoute unique des changements d'état d'auth Supabase
    _authSub = _supabase.auth.onAuthStateChange.listen(_handleAuthChange);
    _checkInitialAuthState();
  }

  Future<void> _checkInitialAuthState() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _handleSignedIn(session.user);
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  void _handleAuthChange(supa.AuthState data) async {
    final event = data.event;
    final session = data.session;
    switch (event) {
      case supa.AuthChangeEvent.signedIn:
        if (session?.user != null) {
          await _handleSignedIn(session!.user);
        }
        break;
      case supa.AuthChangeEvent.userUpdated:
        if (session?.user != null) {
          await _handleSignedIn(session!.user);
        }
        break;
      case supa.AuthChangeEvent.signedOut:
        state = const AuthState.unauthenticated();
        break;
      case supa.AuthChangeEvent.passwordRecovery:
        // Géré par le flux reset côté UI. Pas de changement d'état global ici.
        break;
      default:
        break;
    }
  }

  Future<void> _handleSignedIn(supa.User user) async {
    // Si l'email n'est pas confirmé, rester sur l'écran d'attente
    if (user.emailConfirmedAt == null) {
      state = AuthState.emailPending(
        email: user.email ?? '',
        message: 'Vérifie ton email pour continuer',
      );
      return;
    }

    // Créer le profil si nécessaire (idempotent)
    await _ensureUserProfile(user);

    // Utilisateur authentifié
    state = AuthState.authenticated(user: user);
  }

  Future<void> _ensureUserProfile(supa.User user) async {
    try {
      final row = await _supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      if (row == null) {
        await _supabase.from('users').insert({
          'id': user.id,
          'email': user.email,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (_) {
      // Pas de changement d'état. Le profil pourra être créé plus tard.
    }
  }

  // ---- Actions publiques ----

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AuthState.signingUp();
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutter://login-callback',
        data: {
          'first_name': firstName,
          ...?additionalData,
        },
      );

      if (res.user != null && res.session == null) {
        state = AuthState.emailPending(
          email: email,
          message: 'Un email de confirmation t\'a été envoyé',
        );
        _startResendTimer();
        return AuthResponse.success({'status': 'email_pending'});
      }

      if (res.session?.user != null) {
        await _handleSignedIn(res.session!.user);
        return AuthResponse.success({'status': 'authenticated'});
      }

      state = const AuthState.error(
        message: 'Réponse inattendue du serveur',
        code: 'unexpected',
      );
      return AuthResponse.failure(AuthErrorType.unknown, 'Réponse inattendue du serveur');
    } on supa.AuthException catch (e) {
      final msg = _mapAuthErrorMessage(e);
      state = AuthState.error(message: msg, code: e.statusCode?.toString());
      return AuthResponse.failure(_mapAuthErrorType(e), msg);
    } catch (_) {
      state = const AuthState.error(
        message: 'Une erreur inattendue s\'est produite',
        code: 'unknown',
      );
      return AuthResponse.failure(AuthErrorType.unknown, 'Erreur inconnue');
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (!_checkRateLimit()) {
      state = const AuthState.error(
        message: 'Trop de tentatives. Réessayez dans quelques minutes.',
        code: 'too_many_attempts',
      );
      return AuthResponse.failure(AuthErrorType.tooManyAttempts, 'Trop de tentatives. Réessayez dans quelques minutes.');
    }

    state = const AuthState.signingIn();
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        _resetLoginAttempts();
        await _handleSignedIn(res.user!);
        return AuthResponse.success({'status': 'authenticated'});
      }

      state = const AuthState.error(
        message: 'Connexion échouée',
        code: 'login_failed',
      );
      return AuthResponse.failure(AuthErrorType.wrongPassword, 'Connexion échouée');
    } on supa.AuthException catch (e) {
      _incrementLoginAttempts();
      final msg = _mapAuthErrorMessage(e);
      state = AuthState.error(message: msg, code: e.statusCode?.toString());
      return AuthResponse.failure(_mapAuthErrorType(e), msg);
    } catch (_) {
      _incrementLoginAttempts();
      state = const AuthState.error(
        message: 'Une erreur inattendue s\'est produite',
        code: 'unknown',
      );
      return AuthResponse.failure(AuthErrorType.unknown, 'Erreur inconnue');
    }
  }

  Future<AuthResponse> signOut() async {
    try {
      await _supabase.auth.signOut();
      state = const AuthState.unauthenticated();
      return AuthResponse.success();
    } catch (_) {
      state = const AuthState.error(
        message: 'Erreur lors de la déconnexion',
        code: 'logout_failed',
      );
      return AuthResponse.failure(AuthErrorType.unknown, 'Erreur lors de la déconnexion');
    }
  }

  Future<AuthResponse> resendVerificationEmail(String email) async {
    try {
      await _supabase.auth.resend(
        type: supa.OtpType.signup,
        email: email,
        emailRedirectTo: 'io.supabase.flutter://login-callback',
      );
      if (state.maybeWhen(emailPending: (_, __) => true, orElse: () => false)) {
        state = AuthState.emailPending(
          email: email,
          message: 'Email renvoyé avec succès',
        );
      }
      _startResendTimer();
      return AuthResponse.success();
    } on supa.AuthException catch (e) {
      final msg = _mapAuthErrorMessage(e);
      state = AuthState.error(message: msg, code: e.statusCode?.toString());
      return AuthResponse.failure(_mapAuthErrorType(e), msg);
    } catch (_) {
      state = const AuthState.error(
        message: 'Impossible de renvoyer l\'email',
        code: 'resend_failed',
      );
      return AuthResponse.failure(AuthErrorType.networkError, 'Impossible de renvoyer l\'email');
    }
  }

  Future<AuthResponse> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback',
      );
      return AuthResponse.success();
    } on supa.AuthException catch (e) {
      final msg = _mapAuthErrorMessage(e);
      state = AuthState.error(message: msg, code: e.statusCode?.toString());
      return AuthResponse.failure(_mapAuthErrorType(e), msg);
    } catch (_) {
      state = const AuthState.error(
        message: 'Impossible d\'envoyer l\'email de réinitialisation',
        code: 'reset_failed',
      );
      return AuthResponse.failure(AuthErrorType.networkError, 'Impossible d\'envoyer l\'email de réinitialisation');
    }
  }

  Future<bool> checkEmailAvailability(String email) async {
    try {
      final normalized = email.trim().toLowerCase();
      final res = await _supabase
          .from('users')
          .select('id')
          .eq('email', normalized)
          .maybeSingle();
      return res == null; // true si aucun profil avec cet email
    } catch (_) {
      // En cas d'erreur réseau, ne bloque pas l'inscription côté UI
      return true;
    }
  }

  // ---- Rate limiting helpers ----
  bool _checkRateLimit() {
    if (_lastAttemptTime != null) {
      final dt = DateTime.now().difference(_lastAttemptTime!);
      if (_loginAttempts >= 5 && dt.inMinutes < 10) return false;
      if (dt.inMinutes >= 10) _resetLoginAttempts();
    }
    return true;
  }

  void _incrementLoginAttempts() {
    _loginAttempts++;
    _lastAttemptTime = DateTime.now();
  }

  void _resetLoginAttempts() {
    _loginAttempts = 0;
    _lastAttemptTime = null;
  }

  // ---- Resend email timer ----
  void _startResendTimer() {
    _resendEmailTimer?.cancel();
    _resendEmailTimer = Timer(const Duration(seconds: 60), () {});
  }

  bool get canResendEmail => _resendEmailTimer?.isActive != true;

  // ---- Error mapping ----
  String _mapAuthErrorMessage(supa.AuthException error) {
    final msg = (error.message ?? '').toLowerCase();
    final code = error.statusCode?.toString();

    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'Cet email est déjà utilisé';
    }
    if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
      return 'Email ou mot de passe incorrect';
    }
    if (msg.contains('email not confirmed')) {
      return 'Veuillez confirmer votre email';
    }
    if (msg.contains('weak password')) {
      return 'Le mot de passe est trop faible';
    }
    if (code == '429') {
      return 'Trop de tentatives, réessayez plus tard';
    }
    return error.message ?? 'Erreur inconnue';
  }

  AuthErrorType _mapAuthErrorType(supa.AuthException e) {
    final msg = (e.message ?? '').toLowerCase();
    final code = e.statusCode?.toString();
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return AuthErrorType.emailAlreadyInUse;
    }
    if (msg.contains('email not confirmed')) {
      return AuthErrorType.emailNotVerified;
    }
    if (msg.contains('otp_expired') || msg.contains('expired')) {
      return AuthErrorType.expiredLink;
    }
    if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
      return AuthErrorType.wrongPassword;
    }
    if (code == '429') {
      return AuthErrorType.tooManyAttempts;
    }
    return AuthErrorType.unknown;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _resendEmailTimer?.cancel();
    super.dispose();
  }
}
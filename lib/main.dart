// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:lova/app.dart';
import 'package:lova/shared/providers/annotations_provider.dart';
import 'package:lova/shared/providers/tanks_provider.dart';
import 'package:lova/shared/repositories/annotations_repository_memory.dart';
import 'package:lova/shared/services/tanks_persistence.dart';
import 'package:lova/core/services/firebase_service.dart';  // ⬅️ AJOUT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load();

  await initializeDateFormatting('fr_FR', null);

  // ⬅️ INITIALISER FIREBASE EN PREMIER
  await FirebaseService.initialize();

  // Initialiser Supabase avec gestion d'erreur robuste
  try {
    print("🔍 Tentative d'initialisation Supabase...");

    // Vérifier que les variables sont présentes
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
          'Variables d\'environnement manquantes. '
              'Vérifiez SUPABASE_URL et SUPABASE_ANON_KEY dans .env'
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
    );

    print("✅ Supabase initialisé avec succès");

    // Configurer les listeners auth et deep links
    _setupAuthListener();
    _setupDeepLinkHandler();

  } catch (e, stackTrace) {
    print("❌ Erreur Supabase: $e");
    print("Stack trace: $stackTrace");
  }

  // Initialiser les services de persistance
  final tanksPersistence = await TanksPersistence.create();
  final annotationsRepository = await AnnotationsRepositoryMemory.create();

  runApp(
    ProviderScope(
      overrides: [
        tanksPersistenceProvider.overrideWithValue(tanksPersistence),
        annotationsRepositoryProvider.overrideWithValue(annotationsRepository),
      ],
      child: const App(),
    ),
  );
}

/// Configure le listener pour les changements d'état d'authentification
void _setupAuthListener() {
  Supabase.instance.client.auth.onAuthStateChange.listen(
        (data) {
      final event = data.event;
      final session = data.session;

      print("🔄 Auth event: $event");

      switch (event) {
        case AuthChangeEvent.signedIn:
          print("✅ Utilisateur connecté : ${session?.user.email}");
          // ⬅️ SAUVEGARDER LE FCM TOKEN APRÈS CONNEXION
          FirebaseService.saveFCMTokenForCurrentUser();
          break;

        case AuthChangeEvent.signedOut:
          print("👋 Utilisateur déconnecté");
          break;

        case AuthChangeEvent.tokenRefreshed:
          print("🔄 Token rafraîchi");
          break;

        case AuthChangeEvent.userUpdated:
          print("👤 Utilisateur mis à jour");
          break;

        case AuthChangeEvent.passwordRecovery:
          print("🔑 Récupération de mot de passe");
          break;

        case AuthChangeEvent.mfaChallengeVerified:
          print("🔐 MFA vérifié");
          break;

        case AuthChangeEvent.userDeleted:
          print("🗑️ Utilisateur supprimé");
          break;

        default:
          print("❓ Événement auth non géré : $event");
      }
    },
    onError: (error) {
      print("❌ Erreur dans auth listener: $error");
    },
  );
}

/// Configure le gestionnaire de deep links pour PKCE
void _setupDeepLinkHandler() async {
  try {
    final appLinks = AppLinks();

    // Gérer le lien initial (démarrage à froid de l'app)
    final initialUri = await appLinks.getInitialAppLink();
    if (initialUri != null) {
      print("🔗 Initial deep link: $initialUri");
      await _handleIncomingAuthUri(initialUri);
    }

    // Stream pour les liens suivants pendant que l'app tourne
    appLinks.uriLinkStream.listen(
          (uri) async {
        print("🔗 Incoming deep link: $uri");
        await _handleIncomingAuthUri(uri);
      },
      onError: (error) {
        print("⚠️ AppLinks stream error: $error");
      },
    );
  } catch (e) {
    print("⚠️ AppLinks initialization error: $e");
  }
}

/// Traite les URIs entrants pour l'authentification PKCE
Future<void> _handleIncomingAuthUri(Uri uri) async {
  print("🔍 Processing URI: $uri");
  print("   Scheme: ${uri.scheme}");
  print("   Host: ${uri.host}");
  print("   Path: ${uri.path}");
  print("   Query: ${uri.queryParameters}");

  // Vérifier que c'est bien un callback d'auth pour notre app
  if (uri.scheme != 'loova' || uri.host != 'login-callback') {
    print("⚠️ URI non reconnu, ignoré");
    return;
  }

  // Extraire le code PKCE des paramètres
  final code = uri.queryParameters['code'];
  if (code != null && code.isNotEmpty) {
    try {
      print("🔐 Code PKCE trouvé, échange contre une session...");

      final response = await Supabase.instance.client.auth.exchangeCodeForSession(code);

      if (response.session != null) {
        print("✅ Session créée avec succès via PKCE");
        print("   User: ${response.session!.user.email}");
        print("   Expires at: ${response.session!.expiresAt}");
      }
    } catch (e) {
      print("❌ Erreur exchangeCodeForSession: $e");

      if (e.toString().contains('invalid_grant')) {
        print("   → Code expiré ou déjà utilisé");
      } else if (e.toString().contains('invalid_request')) {
        print("   → Requête invalide, vérifiez la configuration");
      }
    }
    return;
  }

  // Gérer les erreurs OAuth si présentes
  final error = uri.queryParameters['error'];
  if (error != null) {
    print("❌ Erreur OAuth: $error");
    final errorDescription = uri.queryParameters['error_description'];
    if (errorDescription != null) {
      print("   Description: $errorDescription");
    }
    return;
  }

  print("⚠️ Callback reçu mais sans code ni erreur");

  if (uri.fragment.isNotEmpty) {
    print("ℹ️ Fragment détecté mais PKCE utilise les query params, ignoré");
  }
}
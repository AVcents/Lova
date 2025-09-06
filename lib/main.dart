// lib/main.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'shared/services/tanks_persistence.dart';
import 'shared/providers/tanks_provider.dart';
import 'shared/repositories/annotations_repository_memory.dart';
import 'shared/providers/annotations_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // 🧪 TEST avec configuration minimale
  try {
    print("🔍 Tentative d'initialisation Supabase...");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: false,  // Désactive les logs debug
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
    );
    print("✅ Supabase initialisé avec succès");

    // Configurer le listener global pour les deep links et auth state
    _setupAuthListener();

  } catch (e) {
    print("❌ Erreur Supabase: $e");
    // Continue quand même pour voir si l'app fonctionne
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

void _setupAuthListener() {
  // Listener pour gérer les deep links et les changements d'état auth
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    final session = data.session;

    print("🔄 Auth event: $event");

    // Gérer les différents événements
    switch (event) {
      case AuthChangeEvent.signedIn:
        print("✅ Utilisateur connecté : ${session?.user.email}");
        // La création du profil est gérée dans AuthController
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
      default:
        print("❓ Événement auth non géré : $event");
    }
  });
}
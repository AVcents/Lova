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
    );
    print("✅ Supabase initialisé avec succès");
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
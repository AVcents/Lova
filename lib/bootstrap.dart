import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> bootstrap() async {
  // Assure que le moteur Flutter est bien initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // [Ici tu pourras ajouter plus tard : Firebase, dotenv, etc.]

  // Lancement de l'app principale avec Riverpod
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
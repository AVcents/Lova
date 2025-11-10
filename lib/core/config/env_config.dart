import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration centralisée pour les variables d'environnement
class EnvConfig {
  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Mistral AI
  static String get mistralApiKey => dotenv.env['MISTRAL_API_KEY'] ?? '';

  // OpenAI (legacy - à supprimer après migration complète)
  static String get openaiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  /// Vérifie que toutes les variables d'environnement critiques sont définies
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        mistralApiKey.isNotEmpty;
  }

  /// Affiche un résumé de la configuration (sans exposer les secrets)
  static String get configSummary {
    return '''
Configuration Environment:
- Supabase URL: ${supabaseUrl.isNotEmpty ? '✓ Configured' : '✗ Missing'}
- Supabase Anon Key: ${supabaseAnonKey.isNotEmpty ? '✓ Configured' : '✗ Missing'}
- Mistral API Key: ${mistralApiKey.isNotEmpty ? '✓ Configured' : '✗ Missing'}
''';
  }
}

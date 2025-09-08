import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeepLinkHandler {
  static void handleDeepLink(BuildContext context, Uri uri) {
    print("🔗 Deep link reçu : $uri");

    // Extraire les paramètres de l'URL
    final queryParams = uri.queryParameters;
    final errorCode = queryParams['error_code'];
    final errorDescription = queryParams['error_description'];

    // Gérer les différents cas d'erreur
    if (errorCode != null) {
      switch (errorCode) {
        case 'otp_expired':
          // Lien expiré - rediriger vers verify-email avec l'erreur
          final email = Supabase.instance.client.auth.currentUser?.email ?? '';
          context.go(
            '/verify-email?email=$email&error_code=$errorCode&error_description=${Uri.encodeComponent(errorDescription ?? "Lien expiré")}',
          );
          break;

        case 'otp_disabled':
        case 'email_already_confirmed':
          // Email déjà confirmé
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email déjà confirmé. Connecte-toi pour continuer.',
              ),
              backgroundColor: Colors.blue,
            ),
          );
          context.go('/sign-in');
          break;

        case 'invalid_request':
        case 'invalid_token':
          // Token invalide
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lien invalide. ${errorDescription ?? ""}'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/sign-in');
          break;

        default:
          // Erreur inconnue
          print("❌ Erreur deep link non gérée : $errorCode");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorDescription ?? 'Une erreur est survenue'),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/sign-in');
      }
    } else {
      // Pas d'erreur - la confirmation a réussi
      // La redirection post-confirmation est gérée par AuthStateNotifier (via onAuthStateChange)
      print("✅ Deep link sans erreur - confirmation réussie");
    }
  }

  static void setupDeepLinkListener(BuildContext context) {
    // Écouter les changements d'URL pour les deep links
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        // Si on arrive depuis un deep link de confirmation
        final uri = Uri.tryParse(data.session?.providerRefreshToken ?? '');
        if (uri != null && uri.scheme == 'io.supabase.flutter') {
          handleDeepLink(context, uri);
        }
      }
    });
  }
}

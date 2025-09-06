import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ajouté au-dessus du formulaire
            Image.asset(
              'assets/images/lova_logo.png',
              height: 120, // ajuste la taille selon ton besoin
            ),
            const SizedBox(height: 32),

            const SignInForm(),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.go('/sign-up'),
              child: const Text("Pas encore de compte ? Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
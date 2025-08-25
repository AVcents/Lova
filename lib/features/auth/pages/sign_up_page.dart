import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SignUpForm(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/sign-in'),
              child: const Text("Déjà un compte ? Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/features/auth/controller/auth_controller.dart';
import 'package:go_router/go_router.dart';
class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Champ requis';
              if (!value.contains('@')) return 'Email invalide';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onSaved: (value) => _password = value ?? '',
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Au moins 6 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
            obscureText: true,
            onSaved: (value) => _confirmPassword = value ?? '',
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Au moins 6 caractères';
              }
              if (value != _password) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await ref.read(authControllerProvider).signUp(_email, _password);
                  if (context.mounted) {
                    context.go('/dashboard');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text("S'inscrire"),
          ),
        ],
      ),
    );
  }
}
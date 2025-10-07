// lib/features/settings/pages/change_email_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/auth/utils/email_validator.dart';
import 'package:lova/features/settings/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ConsumerState<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _currentEmail = Supabase.instance.client.auth.currentUser?.email;
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Vérifier le mot de passe d'abord
      final email = _currentEmail!;
      final password = _passwordController.text;

      final authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Mot de passe incorrect');
      }

      // Changer l'email
      final service = ref.read(profileServiceProvider);
      final success = await service.changeEmail(_newEmailController.text.trim());

      if (success && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Email envoyé'),
            content: Text(
              'Un email de confirmation a été envoyé à ${_newEmailController.text}.\n\n'
                  'Veuillez cliquer sur le lien dans l\'email pour confirmer votre nouvelle adresse.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer l\'adresse email'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Email actuel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email actuel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentEmail ?? 'Non défini',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nouvel email
            TextFormField(
              controller: _newEmailController,
              decoration: const InputDecoration(
                labelText: 'Nouvel email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L\'email est requis';
                }
                final validation = EmailValidator.validate(value.trim());
                if (!validation.isValid) {
                  return validation.error ?? 'Email invalide';
                }
                if (value.trim().toLowerCase() == _currentEmail?.toLowerCase()) {
                  return 'Le nouvel email doit être différent';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Confirmer email
            TextFormField(
              controller: _confirmEmailController,
              decoration: const InputDecoration(
                labelText: 'Confirmer le nouvel email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez confirmer l\'email';
                }
                if (value.trim() != _newEmailController.text.trim()) {
                  return 'Les emails ne correspondent pas';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 16),

            // Mot de passe pour confirmation
            Text(
              'Confirmez votre mot de passe actuel',
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le mot de passe est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Bouton de confirmation
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changeEmail,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Changer l\'email'),
              ),
            ),

            const SizedBox(height: 16),

            // Avertissement
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vous devrez confirmer votre nouvelle adresse email en cliquant sur le lien qui vous sera envoyé.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// lib/features/settings/pages/change_password_page.dart
// =============================================================================

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Vérifier le mot de passe actuel
      final email = Supabase.instance.client.auth.currentUser?.email;
      if (email == null) throw Exception('Email non trouvé');

      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: _currentPasswordController.text,
      );

      // Changer le mot de passe
      final service = ref.read(profileServiceProvider);
      final success = await service.changePassword(_newPasswordController.text);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe changé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Erreur lors du changement de mot de passe';

        if (e.toString().contains('Invalid login')) {
          errorMessage = 'Mot de passe actuel incorrect';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sécurité du mot de passe',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Utilisez au moins 8 caractères avec des majuscules, minuscules, chiffres et caractères spéciaux.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mot de passe actuel
            TextFormField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
                  },
                ),
              ),
              obscureText: _obscureCurrentPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le mot de passe actuel est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Nouveau mot de passe
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() => _obscureNewPassword = !_obscureNewPassword);
                  },
                ),
              ),
              obscureText: _obscureNewPassword,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nouveau mot de passe est requis';
                }
                if (value.length < 8) {
                  return 'Le mot de passe doit faire au moins 8 caractères';
                }
                if (value == _currentPasswordController.text) {
                  return 'Le nouveau mot de passe doit être différent';
                }
                return null;
              },
            ),

            // Indicateur de force (si vous avez le widget)
            if (_newPasswordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _calculatePasswordStrength(_newPasswordController.text),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getPasswordStrengthColor(_newPasswordController.text),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getPasswordStrengthText(_newPasswordController.text),
                style: TextStyle(
                  fontSize: 12,
                  color: _getPasswordStrengthColor(_newPasswordController.text),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Confirmer le mot de passe
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez confirmer le mot de passe';
                }
                if (value != _newPasswordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Bouton de confirmation
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Changer le mot de passe'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.125;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.125;
    return strength.clamp(0.0, 1.0);
  }

  Color _getPasswordStrengthColor(String password) {
    final strength = _calculatePasswordStrength(password);
    if (strength < 0.3) return Colors.red;
    if (strength < 0.6) return Colors.orange;
    if (strength < 0.8) return Colors.yellow[700]!;
    return Colors.green;
  }

  String _getPasswordStrengthText(String password) {
    final strength = _calculatePasswordStrength(password);
    if (strength < 0.3) return 'Faible';
    if (strength < 0.6) return 'Moyen';
    if (strength < 0.8) return 'Bon';
    return 'Très fort';
  }
}
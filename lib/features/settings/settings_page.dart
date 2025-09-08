import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/domain/auth_state.dart'; // rend AuthStateX (userOrNull, isBusy) disponible
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/shared/providers/theme_mode_provider.dart';
import 'package:lova/shared/widgets/app_scaffold.dart';

final signingOutProvider = StateProvider<bool>((ref) => false);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final user = authState.userOrNull;
    ref.watch(themeModeProvider); // Force rebuild on theme change

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et sous-titre
            _buildHeader(context),

            const SizedBox(height: 32),

            // Section Profil utilisateur
            _buildUserSection(context, user),

            const SizedBox(height: 24),

            // Section Paramètres de l'app
            _buildAppSettingsSection(context),

            const SizedBox(height: 24),

            // Section Conseils matrimoniaux
            _buildMatrimonialSection(context),

            const SizedBox(height: 24),

            // Section Support et aide
            _buildSupportSection(context),

            const SizedBox(height: 40),

            // Bouton de déconnexion
            _buildSignOutButton(context, ref),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF8BBD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'LOVA',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Votre conseiller matrimonial personnel',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, User? user) {
    return _buildSection(
      context,
      title: 'Mon Profil',
      icon: Icons.person,
      children: [
        if (user != null)
          _buildListTile(
            context,
            icon: Icons.email,
            title: 'Email',
            subtitle: user.email ?? 'Non défini',
            onTap: () {
              // Navigation vers édition profil
            },
          )
        else
          _buildListTile(
            context,
            icon: Icons.login,
            title: 'Non connecté',
            subtitle: 'Veuillez vous connecter',
            onTap: () {},
          ),
        _buildListTile(
          context,
          icon: Icons.edit,
          title: 'Modifier mon profil',
          subtitle: 'Préférences et informations personnelles',
          onTap: () {
            // Navigation vers édition profil
          },
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Paramètres de l\'application',
      icon: Icons.settings,
      children: [
        _buildListTile(
          context,
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Gérer les alertes et rappels',
          onTap: () {
            // Navigation vers paramètres notifications
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

            return SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Activer ou désactiver le thème sombre'),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value
                    ? ThemeMode.dark
                    : ThemeMode.light;
              },
            );
          },
        ),
        _buildListTile(
          context,
          icon: Icons.language,
          title: 'Langue',
          subtitle: 'Français',
          onTap: () {
            // Navigation vers paramètres langue
          },
        ),
      ],
    );
  }

  Widget _buildMatrimonialSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Conseils matrimoniaux',
      icon: Icons.psychology,
      children: [
        _buildListTile(
          context,
          icon: Icons.favorite_border,
          title: 'Mes préférences',
          subtitle: 'Type de conseils et domaines d\'intérêt',
          onTap: () {
            // Navigation vers préférences conseils
          },
        ),
        _buildListTile(
          context,
          icon: Icons.history,
          title: 'Historique des conversations',
          subtitle: 'Revoir vos échanges passés',
          onTap: () {
            // Navigation vers historique
          },
        ),
        _buildListTile(
          context,
          icon: Icons.bookmark,
          title: 'Conseils sauvegardés',
          subtitle: 'Vos conseils favoris',
          onTap: () {
            // Navigation vers favoris
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Support et aide',
      icon: Icons.help,
      children: [
        _buildListTile(
          context,
          icon: Icons.help_outline,
          title: 'Centre d\'aide',
          subtitle: 'FAQ et guides d\'utilisation',
          onTap: () {
            // Navigation vers aide
          },
        ),
        _buildListTile(
          context,
          icon: Icons.contact_support,
          title: 'Nous contacter',
          subtitle: 'Support technique et questions',
          onTap: () {
            // Navigation vers contact
          },
        ),
        _buildListTile(
          context,
          icon: Icons.privacy_tip,
          title: 'Confidentialité',
          subtitle: 'Politique de confidentialité',
          onTap: () {
            // Navigation vers politique
          },
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final signingOut = ref.watch(signingOutProvider);
    final isBusy = authState.maybeWhen(
      signingIn: () => true,
      signingUp: () => true,
      orElse: () => false,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: (signingOut || isBusy)
            ? null
            : () async {
                final shouldSignOut = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                      'Êtes-vous sûr de vouloir vous déconnecter ?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Se déconnecter'),
                      ),
                    ],
                  ),
                );

                if (shouldSignOut == true) {
                  try {
                    ref.read(signingOutProvider.notifier).state = true;
                    await ref
                        .read(authStateNotifierProvider.notifier)
                        .signOut();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Déconnecté avec succès')),
                      );

                      // Redirection vers la page de connexion si nécessaire
                      context.go('/sign-in');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
                    }
                  } finally {
                    ref.read(signingOutProvider.notifier).state = false;
                  }
                }
              },
        icon: signingOut
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.logout),
        label: Text(signingOut ? 'Déconnexion...' : 'Se déconnecter'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red.shade700,
          side: BorderSide(color: Colors.red.shade200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFE91E63), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

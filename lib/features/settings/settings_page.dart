// lib/features/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/domain/auth_state.dart';
import 'package:lova/features/settings/services/profile_service.dart';
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
    final profileAsync = ref.watch(currentProfileProvider);
    ref.watch(themeModeProvider);

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),

            // SECTION 1: Mon Profil (le plus consulté)
            _buildUserSection(context, user, profileAsync),
            const SizedBox(height: 24),

            // SECTION 2: Ma Relation
            _buildRelationSection(context, profileAsync),
            const SizedBox(height: 24),

            // SECTION 3: Objectifs & Intérêts
            _buildObjectivesSection(context),
            const SizedBox(height: 24),

            // SECTION 4: Sécurité
            _buildSecuritySection(context),
            const SizedBox(height: 24),

            // SECTION 5: Préférences
            _buildPreferencesSection(context, ref),
            const SizedBox(height: 24),

            // SECTION 6: Abonnement
            _buildSubscriptionSection(context, profileAsync),
            const SizedBox(height: 24),

            // SECTION 7: Support & Aide
            _buildSupportSection(context),
            const SizedBox(height: 24),

            // SECTION 8: Légal
            _buildLegalSection(context),
            const SizedBox(height: 40),

            // Actions de compte
            _buildAccountActions(context, ref),
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
                'Paramètres',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gérez votre compte et vos préférences',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, User? user, AsyncValue<UserProfile?> profileAsync) {
    final profile = profileAsync.valueOrNull;

    return _buildSection(
      context,
      title: 'Mon Profil',
      icon: Icons.person,
      children: [
        if (user != null && profile != null) ...[
          _buildListTile(
            context,
            icon: Icons.email,
            title: user.email ?? 'Non défini',
            subtitle: 'Adresse email',
            onTap: null,
          ),
          if (profile.firstName != null)
            _buildListTile(
              context,
              icon: Icons.badge,
              title: profile.firstName!,
              subtitle: profile.prenom ?? 'Aucun surnom',
              onTap: null,
            ),
        ],
        _buildListTile(
          context,
          icon: Icons.edit,
          title: 'Modifier mon profil',
          subtitle: 'Photo, informations personnelles',
          onTap: () => context.push('/settings/edit-profile'),
        ),
      ],
    );
  }

  Widget _buildRelationSection(BuildContext context, AsyncValue<UserProfile?> profileAsync) {
    final profile = profileAsync.valueOrNull;
    final hasRelation = profile?.relationId != null;

    return _buildSection(
      context,
      title: 'Ma Relation',
      icon: Icons.favorite,
      children: [
        _buildListTile(
          context,
          icon: hasRelation ? Icons.link : Icons.link_off,
          title: hasRelation ? 'Relation liée' : 'Pas de relation',
          subtitle: hasRelation
              ? 'Gérer votre relation partenaire'
              : 'Liez votre compte avec votre partenaire',
          onTap: () => context.push('/link-relation'),
        ),
      ],
    );
  }

  Widget _buildObjectivesSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Objectifs & Centres d\'intérêt',
      icon: Icons.psychology,
      children: [
        _buildListTile(
          context,
          icon: Icons.favorite_border,
          title: 'Mes objectifs relationnels',
          subtitle: 'Définir vos priorités de couple',
          onTap: () => context.push('/settings/objectives_page'),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Sécurité',
      icon: Icons.security,
      children: [
        _buildListTile(
          context,
          icon: Icons.email_outlined,
          title: 'Changer l\'adresse email',
          subtitle: 'Modifier votre email de connexion',
          onTap: () => context.push('/settings/change-email'),
        ),
        _buildListTile(
          context,
          icon: Icons.lock_outline,
          title: 'Changer le mot de passe',
          subtitle: 'Mettre à jour votre mot de passe',
          onTap: () => context.push('/settings/change-password'),
        ),
        _buildListTile(
          context,
          icon: Icons.phonelink_lock,
          title: 'Authentification à deux facteurs',
          subtitle: 'Bientôt disponible',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context,
      title: 'Préférences',
      icon: Icons.tune,
      children: [
        Consumer(
          builder: (context, ref, _) {
            final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

            return SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Activer ou désactiver le thème sombre'),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dark_mode,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
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
          icon: Icons.notification_important,
          title: 'Test Notifications',
          subtitle: 'Tester l\'envoi de notifications push',
          onTap: () => context.push('/settings/test-notifications'),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(BuildContext context, AsyncValue<UserProfile?> profileAsync) {
    final profile = profileAsync.valueOrNull;
    final tier = profile?.subscriptionTier ?? 'free';
    final isPremium = tier != 'free';

    return _buildSection(
      context,
      title: 'Abonnement',
      icon: Icons.workspace_premium,
      children: [
        _buildListTile(
          context,
          icon: isPremium ? Icons.star : Icons.star_border,
          title: isPremium ? 'Plan Premium' : 'Plan Gratuit',
          subtitle: isPremium ? 'Gérer votre abonnement' : 'Découvrir les avantages Premium',
          onTap: () => context.push('/settings/subscription'),
        ),
        if (isPremium)
          _buildListTile(
            context,
            icon: Icons.receipt_long,
            title: 'Historique des paiements',
            subtitle: 'Factures et reçus',
            onTap: () => context.push('/settings/billing-history'),
          ),
        _buildListTile(
          context,
          icon: Icons.share,
          title: 'Inviter des amis',
          subtitle: 'Gagnez des jours Premium gratuits',
          onTap: () => context.push('/settings/referral'),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Support & Aide',
      icon: Icons.help,
      children: [
        _buildListTile(
          context,
          icon: Icons.help_outline,
          title: 'Centre d\'aide',
          subtitle: 'FAQ et guides d\'utilisation',
          onTap: () => context.push('/help'),
        ),
        _buildListTile(
          context,
          icon: Icons.bug_report,
          title: 'Signaler un bug',
          subtitle: 'Nous aider à améliorer l\'app',
          onTap: () => context.push('/settings/report-bug'),
        ),
        _buildListTile(
          context,
          icon: Icons.contact_support,
          title: 'Nous contacter',
          subtitle: 'Support technique et questions',
          onTap: () => context.push('/contact'),
        ),
        _buildListTile(
          context,
          icon: Icons.bar_chart,
          title: 'Mon activité',
          subtitle: 'Statistiques et engagement',
          onTap: () => context.push('/settings/activity'),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Légal',
      icon: Icons.gavel,
      children: [
        _buildListTile(
          context,
          icon: Icons.privacy_tip,
          title: 'Politique de confidentialité',
          subtitle: 'Protection de vos données',
          onTap: () => context.push('/privacy'),
        ),
        _buildListTile(
          context,
          icon: Icons.description,
          title: 'Conditions d\'utilisation',
          subtitle: 'Nos conditions générales',
          onTap: () => context.push('/terms'),
        ),
        _buildListTile(
          context,
          icon: Icons.info_outline,
          title: 'Mentions légales',
          subtitle: 'Informations sur l\'éditeur',
          onTap: () => context.push('/legal'),
        ),
        _buildListTile(
          context,
          icon: Icons.info,
          title: 'À propos',
          subtitle: 'Version 1.0.0',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'LOOVA',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.favorite, color: Color(0xFFE91E63)),
              children: const [
                Text('Votre conseiller matrimonial personnel basé sur l\'IA.\n\n'
                    'Développé avec amour pour renforcer les relations.'),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context, WidgetRef ref) {
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
      child: Column(
        children: [
          ElevatedButton.icon(
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
                    context.go('/sign-in');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e')),
                    );
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

          const SizedBox(height: 16),

          TextButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer le compte'),
                  content: const Text(
                    'Cette action est irréversible. Toutes vos données seront supprimées.\n\n'
                        'Êtes-vous absolument sûr ?',
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
                      child: const Text('Supprimer définitivement'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final service = ref.read(profileServiceProvider);
                final success = await service.deleteAccount();
                if (success && context.mounted) {
                  context.go('/sign-in');
                }
              }
            },
            icon: const Icon(Icons.delete_forever, size: 20),
            label: const Text('Supprimer mon compte'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
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
        required VoidCallback? onTap,
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
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}
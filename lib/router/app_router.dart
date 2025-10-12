// lib/router/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/relation/relation_dashboard_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:lova/features/library_us/library_us_page.dart';
import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/onboarding/providers/onboarding_controller.dart';
import 'package:lova/features/onboarding/presentation/onboarding_flow.dart';

// Pages d'authentification
import 'package:lova/features/auth/pages/sign_in_page.dart';
import 'package:lova/features/auth/pages/sign_up_page.dart';
import 'package:lova/features/auth/pages/forgot_password_page.dart';
import 'package:lova/features/auth/pages/verify_email_page.dart';
import 'package:lova/features/chat/chat_couple_page.dart';
import 'package:lova/features/chat/chat_lova_page.dart';
import 'package:lova/features/mediation/mediation_flow.dart';
import 'package:lova/features/profile/profile_page.dart';
import 'package:lova/features/relation_linking/presentation/link_relation_page.dart';
import 'package:lova/features/settings/settings_page.dart';


// Pages de paramètres (imports corrigés)
import 'package:lova/features/settings/services/pages/change_email_page.dart'; // Contient ChangeEmailPage ET ChangePasswordPage
import 'package:lova/features/settings/services/pages/edit_profiles_page.dart'; // Contient EditProfilePage
import 'package:lova/features/settings/services/pages/objectives_page.dart'; // 👈 NOUVEAU

import 'package:lova/shared/widgets/bottom_nav_shell.dart';

import 'package:lova/features/me_dashboard/presentation/checkin_page.dart';
import 'package:lova/features/me_dashboard/presentation/journal_page.dart';
import 'package:lova/features/me_dashboard/presentation/rituals_selection_page.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/rituals_history_section.dart' as rituals;
import 'package:lova/features/me_dashboard/presentation/widgets/checkins_history_section.dart' as checkins;
import 'package:lova/features/me_dashboard/presentation/widgets/journal_history_section.dart' as journals;
import 'package:lova/features/me_dashboard/presentation/emotional_history_page.dart';

// Imports pour les routes Intentions
import 'package:lova/features/me_dashboard/presentation/intentions_overview_page.dart';
import 'package:lova/features/me_dashboard/presentation/intention_creation_wizard.dart';
import 'package:lova/features/me_dashboard/presentation/intention_detail_page.dart';
import 'package:lova/features/me_dashboard/presentation/intention_reflection_page.dart';

import 'package:lova/features/us_dashboard/screens/checkin/couple_checkin_screen.dart';
import 'package:lova/features/us_dashboard/screens/checkin/couple_checkin_results_screen.dart';
import 'package:lova/features/us_dashboard/screens/games/connection_games_screen.dart';
import 'package:lova/features/us_dashboard/screens/games/games_library_screen.dart';
import 'package:lova/features/us_dashboard/screens/games/intimacy_card_game_screen.dart';
import 'package:lova/features/us_dashboard/screens/rituals/couple_rituals_library_screen.dart';
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshStream(Stream stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard', // TEMPORAIRE: bypass onboarding
    refreshListenable: GoRouterRefreshStream(
      supa.Supabase.instance.client.auth.onAuthStateChange,
    ),
    debugLogDiagnostics: true,
    routes: [
      // Routes d'authentification
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final errorCode = state.uri.queryParameters['error_code'];
          return VerifyEmailPage(email: email, errorCode: errorCode);
        },
      ),

      // Gate et onboarding
      GoRoute(
        path: '/gate',
        builder: (context, state) => const OnboardingGatePage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: OnboardingFlow.name,
        builder: (context, state) => const OnboardingFlow(),
      ),

      // Autres routes hors navigation
      GoRoute(
        path: '/mediation',
        builder: (context, state) => const MediationFlowPage(),
      ),

      // Routes de paramètres (hors bottom nav)
      GoRoute(
        path: '/settings/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/settings/objectives_page',
        builder: (context, state) => const ObjectivesPage(),
      ),
      GoRoute(
        path: '/settings/change-email',
        builder: (context, state) => const ChangeEmailPage(),
      ),
      GoRoute(
        path: '/settings/change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const PlaceholderPage(title: 'Notifications'),
      ),
      GoRoute(
        path: '/settings/preferences',
        builder: (context, state) => const PlaceholderPage(title: 'Préférences'),
      ),

      // Routes de support et aide (placeholders)
      GoRoute(
        path: '/chat/history',
        builder: (context, state) => const PlaceholderPage(title: 'Historique'),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const PlaceholderPage(title: 'Favoris'),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const PlaceholderPage(title: 'Centre d\'aide'),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const PlaceholderPage(title: 'Nous contacter'),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PlaceholderPage(title: 'Confidentialité'),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const PlaceholderPage(title: 'Conditions d\'utilisation'),
      ),
      // Routes ME Dashboard
      GoRoute(
        path: '/me/checkin',
        name: 'meCheckin',
        builder: (context, state) => const CheckinPage(),
      ),
      GoRoute(
        path: '/me/journal',
        name: 'meJournal',
        builder: (context, state) => const JournalPage(),
      ),
      GoRoute(
        path: '/me/rituals',
        name: 'meRituals',
        builder: (context, state) => const RitualsSelectionPage(),
      ),
      GoRoute(
        path: '/me/ritual-history',
        name: 'meRitualHistory',
        builder: (context, state) => const rituals.RitualsHistorySection(),
      ),
      GoRoute(
        path: '/me/checkins-history',
        name: 'meCheckinsHistory',
        builder: (context, state) => const checkins.CheckinsHistoryPage(),
      ),
      GoRoute(
        path: '/me/journal-history',
        name: 'meJournalHistory',
        builder: (context, state) => const journals.JournalHistorySection(),
      ),
      GoRoute(
        path: '/emotional-history',
        name: 'emotionalHistory',
        builder: (context, state) => const EmotionalHistoryPage(),
      ),
      // Dans votre GoRouter config
      GoRoute(
        path: '/intentions',
        name: 'intentions',
        builder: (context, state) => const IntentionsOverviewPage(),
      ),
      GoRoute(
        path: '/intentions/create',
        name: 'intentionsCreate',
        builder: (context, state) => const IntentionCreationWizard(),
      ),
      GoRoute(
        path: '/intentions/detail/:id',
        name: 'intentionDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return IntentionDetailPage(intentionId: id);
        },
      ),
      GoRoute(
        path: '/intentions/reflection',
        name: 'intentionReflection',
        builder: (context, state) => const IntentionReflectionPage(),
      ),

      // Routes US Dashboard
      GoRoute(
        path: '/couple-checkin',
        name: 'coupleCheckin',
        builder: (context, state) => const CoupleCheckinScreen(),
      ),
      GoRoute(
        path: '/couple-checkin-results',
        name: 'coupleCheckinResults',
        builder: (context, state) => const CoupleCheckinResultsScreen(),
      ),
      GoRoute(
        path: '/couple-rituals',
        name: 'coupleRituals',
        builder: (context, state) => const CoupleRitualsLibraryScreen(),
      ),
      GoRoute(
        path: '/connection-games',
        name: 'connectionGames',
        builder: (context, state) => const ConnectionGamesScreen(),
      ),
      GoRoute(
        path: '/create-couple-ritual',
        builder: (context, state) => const CoupleRitualsLibraryScreen(),
      ),
      // Route bibliothèque (remplace le placeholder)
      GoRoute(
        path: '/connection-games',
        builder: (context, state) => const GamesLibraryScreen(),
      ),

// Route jeu intimité
      GoRoute(
        path: '/intimacy-card-game',
        builder: (context, state) => const IntimacyCardGameScreen(),
      ),

      // Routes avec bottom navigation
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const RelationDashboardPage(),
          ),
          GoRoute(
            path: '/chat-lova',
            builder: (context, state) => const ChatLovaPage(),
          ),
          GoRoute(
            path: '/chat-couple',
            builder: (context, state) {
              final messageIdStr = state.uri.queryParameters['messageId'];
              final messageId = messageIdStr != null
                  ? int.tryParse(messageIdStr)
                  : null;
              return ChatCouplePage(initialMessageId: messageId);
            },
          ),
          GoRoute(
            path: '/library-us',
            builder: (context, state) {
              final filterName = state.uri.queryParameters['filter'];
              AnnotationTag? filter;
              if (filterName != null) {
                try {
                  filter = AnnotationTag.values.firstWhere(
                        (tag) => tag.name == filterName,
                  );
                } catch (_) {}
              }

              final extra = state.extra as Map<String, dynamic>?;
              final coupleId = extra?['coupleId'] ?? 'couple_001';
              final scrollToMessage =
              extra?['scrollToMessage'] as Function(int)?;

              return LibraryUsPage(
                initialFilter: filter,
                coupleId: coupleId,
                scrollToMessage: scrollToMessage,
              );
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/link-relation',
            builder: (context, state) => const LinkRelationPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final ref = ProviderScope.containerOf(context);
      final auth = ref.read(authStateNotifierProvider);

      final isAuth = auth.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      final isEmailPending = auth.maybeWhen(
        emailPending: (_, __) => true,
        orElse: () => false,
      );

      final isGoingToAuth =
          state.fullPath == '/sign-in' ||
              state.fullPath == '/sign-up' ||
              state.fullPath == '/forgot-password' ||  // 👈 AJOUT
              (state.fullPath?.startsWith('/verify-email') == true);

      // CHANGEMENT: Permettre l'accès direct au dashboard si authentifié
      if (isAuth && (state.fullPath == '/dashboard' ||
          state.fullPath == '/gate' ||
          state.fullPath?.startsWith('/settings') == true ||
          state.fullPath?.startsWith('/chat') == true ||
          state.fullPath?.startsWith('/library') == true ||
          state.fullPath?.startsWith('/profile') == true)) {
        return null;
      }


      if (isAuth && isGoingToAuth) {
        // Ne plus forcer /gate, aller directement au dashboard
        return '/dashboard';
      }

      if (!isAuth && !isGoingToAuth) {
        if (isEmailPending) {
          final email = auth.maybeWhen(
            emailPending: (e, __) => e,
            orElse: () => '',
          );
          return '/verify-email?email=$email';
        }
        return '/sign-in';
      }

      if (!isAuth && isEmailPending && state.fullPath != '/verify-email') {
        final email = auth.maybeWhen(
          emailPending: (e, __) => e,
          orElse: () => '',
        );
        return '/verify-email?email=$email';
      }

      return null;
    },
  );
}

class OnboardingGatePage extends ConsumerWidget {
  const OnboardingGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(hasCompletedOnboardingProvider);

    return asyncStatus.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) {
        // En cas d'erreur, aller au dashboard par défaut
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/dashboard');
        });
        return const SizedBox.shrink();
      },
      data: (done) {
        // Si onboarding complété OU si erreur de check, aller au dashboard
        // Sinon aller à l'onboarding
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // CHANGEMENT: par défaut aller au dashboard
          // L'onboarding ne se déclenche que si explicitement non complété
          if (done == false) {
            context.go('/onboarding');
          } else {
            context.go('/dashboard');
          }
        });
        return const SizedBox.shrink();
      },
    );
  }
}

// Page placeholder pour les fonctionnalités à venir
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Fonctionnalité bientôt disponible',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
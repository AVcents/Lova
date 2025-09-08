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

// 📹 Pages à créer plus tard (écrans vides pour l'instant)
import 'package:lova/features/auth/pages/sign_in_page.dart';
import 'package:lova/features/auth/pages/sign_up_page.dart';
import 'package:lova/features/auth/pages/verify_email_page.dart';
import 'package:lova/features/chat/chat_couple_page.dart';
import 'package:lova/features/chat/chat_lova_page.dart';
import 'package:lova/features/checkin/weekly_checkin_page.dart';
import 'package:lova/features/mediation/mediation_flow.dart';
import 'package:lova/features/profile/profile_page.dart';
import 'package:lova/features/relation_linking/presentation/link_relation_page.dart';
import 'package:lova/features/settings/settings_page.dart';
import 'package:lova/shared/widgets/bottom_nav_shell.dart';

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
    initialLocation: '/sign-in',
    refreshListenable: GoRouterRefreshStream(
      supa.Supabase.instance.client.auth.onAuthStateChange,
    ),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) {
          // Récupérer l'email et les éventuelles erreurs depuis les query params
          final email = state.uri.queryParameters['email'] ?? '';
          final errorCode = state.uri.queryParameters['error_code'];
          return VerifyEmailPage(email: email, errorCode: errorCode);
        },
      ),
      GoRoute(
        path: '/mediation',
        builder: (context, state) => const MediationFlowPage(),
      ),
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
              // Récupérer le messageId depuis les query params
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
              // Récupérer les paramètres depuis l'URL ou extra
              final filterName = state.uri.queryParameters['filter'];
              AnnotationTag? filter;
              if (filterName != null) {
                try {
                  filter = AnnotationTag.values.firstWhere(
                    (tag) => tag.name == filterName,
                  );
                } catch (_) {
                  // Si le filtre n'est pas valide, on l'ignore
                }
              }

              // Récupérer les données passées via extra
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
          GoRoute(
            path: '/weekly-checkin',
            builder: (context, state) => const WeeklyCheckinPage(),
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
          (state.fullPath?.startsWith('/verify-email') == true);

      if (isAuth && isGoingToAuth) {
        return '/dashboard';
      }

      if (!isAuth && !isGoingToAuth) {
        // Si email en attente, forcer la page de vérification
        if (isEmailPending) {
          final email = auth.maybeWhen(
            emailPending: (e, __) => e,
            orElse: () => '',
          );
          return '/verify-email?email=$email';
        }
        return '/sign-in';
      }

      // Si l'utilisateur n'est pas authentifié mais essaie de sortir du flow auth alors qu'il est en emailPending
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

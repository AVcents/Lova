// lib/shared/navigation/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/controller/auth_controller.dart';
import 'package:lova/features/relation/relation_dashboard_page.dart';
import '../../features/library_us/library_us_page.dart';
import '../../shared/models/message_annotation.dart';

// 📹 Pages à créer plus tard (écrans vides pour l'instant)
import '../features/onboarding/onboarding_page.dart';
import '../features/auth/pages/sign_in_page.dart';
import '../features/auth/pages/sign_up_page.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/mediation/mediation_flow.dart';
import '../features/chat/chat_lova_page.dart';
import '../features/chat/chat_couple_page.dart';
import '../features/settings/settings_page.dart';
import '../features/relation_linking/presentation/link_relation_page.dart';
import '../features/profile/profile_page.dart';
import '../features/checkin/weekly_checkin_page.dart';
import '../shared/widgets/bottom_nav_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/sign-in',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
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
              final messageId = messageIdStr != null ? int.tryParse(messageIdStr) : null;
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
              final scrollToMessage = extra?['scrollToMessage'] as Function(int)?;

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
      final user = ref.read(currentUserProvider).value;

      final isGoingToAuth = state.fullPath == '/sign-in' || state.fullPath == '/sign-up';

      if (user != null && isGoingToAuth) {
        return '/dashboard';
      }

      if (user == null && state.fullPath == '/dashboard') {
        return '/sign-in';
      }

      return null;
    },
  );
}
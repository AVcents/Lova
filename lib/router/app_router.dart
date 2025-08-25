import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/relation/relation_dashboard_page.dart';

// 🔹 Pages à créer plus tard (écrans vides pour l'instant)
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
            builder: (context, state) => const ChatCouplePage(),
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
  );
}
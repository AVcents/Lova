import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lova/router/app_router.dart';
import 'package:lova/shared/providers/theme_mode_provider.dart';
import 'package:lova/theme/app_theme.dart';
import 'features/auth/controller/auth_state_notifier.dart';

class AuthStateListener extends ConsumerStatefulWidget {
  final Widget child;
  const AuthStateListener({required this.child, super.key});

  @override
  ConsumerState<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends ConsumerState<AuthStateListener> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authStateNotifierProvider, (previous, next) {
      // Listen to auth state changes
    });
    return widget.child;
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final uid = Supabase.instance.client.auth.currentUser?.id ?? 'signedOut';

    return AuthStateListener(
      child: ProviderScope(
        key: ValueKey(uid), // reset global state when user changes
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'LOVA',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
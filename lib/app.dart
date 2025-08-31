import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/providers/theme_mode_provider.dart';

import 'theme/app_theme.dart';
import 'router/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LOVA',
      theme: AppTheme.light, // à créer dans app_theme.dart
      darkTheme: AppTheme.dark,
      themeMode: mode,
      routerConfig: AppRouter.router, // à créer dans app_router.dart
    );
  }
}
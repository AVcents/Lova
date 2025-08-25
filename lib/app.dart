import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LOVA',
      theme: AppTheme.light, // à créer dans app_theme.dart
      routerConfig: AppRouter.router, // à créer dans app_router.dart
    );
  }
}
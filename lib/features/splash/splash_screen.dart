import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _onAnimationComplete() async {
    // Attendre 500ms après la fin de l'animation
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Vérifier si user connecté
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RepaintBoundary( // <-- Solution 4 : Ajoutez ici
          child: Lottie.asset(
            'assets/animations/splash_loova_fixed.json',
            // Votre fichier corrigé
            controller: _controller,
            frameRate: FrameRate.max,
            // <-- Solution 1 : Ajoutez cette ligne
            options: LottieOptions( // <-- Solution 1 : Ajoutez ces options
              enableMergePaths: true,
            ),
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward()
                ..addStatusListener((status) {
                  if (status == AnimationStatus.completed) {
                    _onAnimationComplete();
                  }
                });
            },
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
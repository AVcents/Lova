import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond (à remplacer avec votre image)
          Positioned.fill(
            child: Image.asset(
              'assets/images/lova_welcome_bg.jpg', // Remplacez avec votre image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient si l'image n'est pas trouvée
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [const Color(0xFF1A1A1A), const Color(0xFF0D0F12)]
                          : [const Color(0xFFF7F2F5), const Color(0xFFFFE0EC)],
                    ),
                  ),
                );
              },
            ),
          ),

          // Overlay sombre avec gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          // Boutons en bas
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Bouton principal "Get Started"
                  Expanded(
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          bottomLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.go('/sign-up'),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            bottomLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Connexion/liaison entre les deux boutons
                  Container(
                    width: 20,
                    height: 64,
                    color: colorScheme.primary,
                    child: CustomPaint(
                      painter: ConnectionPainter(color: colorScheme.primary),
                    ),
                  ),

                  // Bouton secondaire pour la connexion
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        // Go to sign-in
                        onTap: () => context.go('/sign-in'),
                        customBorder: const CircleBorder(),
                        child: const Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alternative avec un design plus fluide
          // Décommentez cette section et commentez celle du dessus pour un style différent
          /*
          Positioned(
            left: 24,
            right: 24,
            bottom: 60,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Bouton principal avec padding pour le bouton circulaire
                Container(
                  height: 64,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.go('/sign-up'),
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.only(left: 32, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bouton circulaire superposé
                Positioned(
                  right: 0,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF0D0F12) : const Color(0xFFF7F2F5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => context.go('/sign-in'),
                        customBorder: const CircleBorder(),
                        child: Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          */
        ],
      ),
    );
  }
}

// Painter personnalisé pour créer la connexion fluide entre les boutons
class ConnectionPainter extends CustomPainter {
  final Color color;

  ConnectionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Créer une courbe de connexion
    path.moveTo(0, size.height / 2 - 32);
    path.lineTo(0, size.height / 2 + 32);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 + 32,
      size.width,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 - 32,
      0,
      size.height / 2 - 32,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

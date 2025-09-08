import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Bouton Google
        _SocialButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // TODO: Implémenter Google Sign In
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Connexion Google bientôt disponible'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          icon: Image.asset(
            'assets/icons/google.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.g_mobiledata, size: 24);
            },
          ),
          label: 'Continuer avec Google',
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
        ),

        const SizedBox(height: 12),

        // Bouton Apple (uniquement sur iOS)
        if (Theme.of(context).platform == TargetPlatform.iOS) ...[
          _SocialButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Implémenter Apple Sign In
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Connexion Apple bientôt disponible'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.apple, size: 24),
            label: 'Continuer avec Apple',
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ],
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            elevation: 1,
            child: InkWell(
              onTap: widget.onPressed,
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon,
                    const SizedBox(width: 12),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.foregroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

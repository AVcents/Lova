import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/data/auth_providers.dart';
import 'package:lova/features/auth/domain/auth_state.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  final String email;
  final String? errorCode;

  const VerifyEmailPage({super.key, required this.email, this.errorCode});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage>
    with TickerProviderStateMixin {
  late AnimationController _emailIconController;
  late AnimationController _checkController;
  late Animation<double> _emailIconAnimation;
  late Animation<double> _checkAnimation;

  bool _isResending = false;
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _countdownTimer;
  bool _isVerified = false;
  String? _resendMessage;
  ProviderSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();

    // Animations
    _emailIconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _emailIconAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _emailIconController, curve: Curves.easeInOut),
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Démarrer le compte à rebours
    _startCountdown();

    // Gérer les erreurs initiales
    _handleInitialError();

    _authSub = ref.listenManual<AuthState>(authStateNotifierProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        authenticated: (user) {
          if (!_isVerified) {
            _handleVerificationSuccess();
          }
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _emailIconController.dispose();
    _checkController.dispose();
    _countdownTimer?.cancel();
    _authSub?.close();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleInitialError() {
    if (widget.errorCode == 'otp_expired') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Le lien a expiré. Renvoie un nouvel email.'),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }
  }

  Future<void> _resendEmail() async {
    if (!_canResend || _isResending) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isResending = true;
      _resendMessage = null;
    });

    await ref
        .read(authRepositoryProvider)
        .resendConfirmationEmail(widget.email);

    setState(() {
      _resendMessage = 'Email envoyé avec succès !';
    });
    _startCountdown();

    setState(() {
      _isResending = false;
    });

    // Effacer le message après 5 secondes
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _resendMessage = null;
        });
      }
    });
  }

  Future<void> _handleVerificationSuccess() async {
    setState(() {
      _isVerified = true;
    });

    // Animation de succès
    await _checkController.forward();

    // Attendre 5 secondes pour montrer le succès
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation email ou check
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _isVerified
                      ? ScaleTransition(
                          scale: _checkAnimation,
                          child: Container(
                            key: const ValueKey('check'),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              size: 72,
                              color: Colors.green,
                            ),
                          ),
                        )
                      : ScaleTransition(
                          scale: _emailIconAnimation,
                          child: Container(
                            key: const ValueKey('email'),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(
                                0.06,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.mail_outline,
                              size: 72,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Vérifie ta boîte mail',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Nous avons envoyé un lien à ${widget.email}.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_resendMessage != null) ...[
                  Text(
                    _resendMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_canResend && !_isResending)
                        ? _resendEmail
                        : null,
                    child: _isResending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _canResend
                                ? 'Renvoyer l\'email'
                                : 'Renvoyer dans $_resendCountdown s',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/utils/email_validator.dart';
import 'package:lova/features/auth/utils/password_validator.dart';
import 'package:lova/features/auth/widgets/password_strength_indicator.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Animation controllers
  late AnimationController _shakeController;
  late AnimationController _formController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _formFadeAnimation;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;

  // Focus nodes pour effet glow
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _confirmPasswordFocused = false;

  @override
  void initState() {
    super.initState();

    // Controllers d'animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animations
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _formSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );

    _formFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _formController, curve: const Interval(0.3, 1)),
    );

    // Focus listeners
    _emailFocusNode.addListener(() {
      setState(() => _emailFocused = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _passwordFocused = _passwordFocusNode.hasFocus);
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(
            () => _confirmPasswordFocused = _confirmPasswordFocusNode.hasFocus,
      );
    });

    // Démarrer l'animation du formulaire après un délai
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shakeController.dispose();
    _formController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    HapticFeedback.lightImpact();

    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Veuillez accepter les conditions d\'utilisation',
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final authNotifier = ref.read(authStateNotifierProvider.notifier);
    final response = await authNotifier.signUp(
      email: email,
      password: password,
    );

    if (response.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vérifie ton e‑mail pour confirmer ton compte'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(milliseconds: 1200),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          context.go('/verify-email?email=$email');
        }
      }
    } else {
      final error = response.message ?? 'Erreur inconnue';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateNotifierProvider);
    final isLoading = authState.maybeWhen(
      signingUp: () => true,
      orElse: () => false,
    );

    final isDark = theme.brightness == Brightness.dark;
    final password = _passwordController.text;
    final passwordValidation = password.isNotEmpty
        ? PasswordValidator.validate(password)
        : null;

    return Scaffold(
      body: Stack(
        children: [
          // Background statique harmonisé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  const Color(0xFF1A0F1C),
                  const Color(0xFF2D1B2E),
                  const Color(0xFF1A0F1C),
                ]
                    : [
                  const Color(0xFFFFF0F5),
                  const Color(0xFFFFE4F1),
                  const Color(0xFFFFF0F5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32),

                          // En-tête avec logo et titre harmonisés
                          Column(
                            children: [
                              // Logo avec taille standardisée
                              Image.asset(
                                'assets/images/lova_logo.png',
                                height: 160,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 16),
                              // Titre principal
                              Text(
                                'Inscription',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Sous-titre
                              Text(
                                'Rejoins notre communauté !',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Champs de formulaire animés
                          FadeTransition(
                            opacity: _formFadeAnimation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(
                                  0,
                                  _formSlideAnimation.value / 80,
                                ),
                                end: Offset.zero,
                              ).animate(_formController),
                              child: Column(
                                children: [

                                  // Champ Email avec effet glow
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _emailFocused
                                          ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF3D86,
                                          ).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                          : [],
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      focusNode: _emailFocusNode,
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      style: const TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        labelText: 'Adresse email',
                                        labelStyle: TextStyle(
                                          color: _emailFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.6),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail_outline_rounded,
                                          color: _emailFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.4),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF3D86),
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez saisir une adresse email';
                                        }
                                        final res = EmailValidator.validate(
                                          value.trim(),
                                        );
                                        if (!res.isValid) {
                                          return res.error ??
                                              'Adresse email invalide';
                                        }
                                        if (res.suggestion != null &&
                                            res.suggestion !=
                                                value.trim().toLowerCase()) {
                                          return 'Vouliez-vous dire ${res.suggestion} ?';
                                        }
                                        return null;
                                      },
                                      autofillHints: const [
                                        AutofillHints.email,
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Champ Mot de passe avec effet glow
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _passwordFocused
                                          ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF3D86,
                                          ).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                          : [],
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      obscureText: !_passwordVisible,
                                      style: const TextStyle(fontSize: 16),
                                      onChanged: (_) => setState(() {}),
                                      // Pour mettre à jour l'indicateur
                                      decoration: InputDecoration(
                                        labelText: 'Mot de passe',
                                        labelStyle: TextStyle(
                                          color: _passwordFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.6),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: _passwordFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.4),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: theme
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.4),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                              !_passwordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF3D86),
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez saisir un mot de passe';
                                        }
                                        final result =
                                        PasswordValidator.validate(value);
                                        if (!result.isValid) {
                                          return 'Mot de passe trop faible';
                                        }
                                        return null;
                                      },
                                      autofillHints: const [
                                        AutofillHints.newPassword,
                                      ],
                                    ),
                                  ),

                                  // Indicateur de force du mot de passe
                                  if (passwordValidation != null) ...[
                                    const SizedBox(height: 8),
                                    PasswordStrengthIndicator(
                                      validation: passwordValidation,
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // Champ Confirmer mot de passe avec effet glow
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _confirmPasswordFocused
                                          ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF3D86,
                                          ).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                          : [],
                                    ),
                                    child: TextFormField(
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocusNode,
                                      obscureText: !_confirmPasswordVisible,
                                      style: const TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        labelText: 'Confirmer le mot de passe',
                                        labelStyle: TextStyle(
                                          color: _confirmPasswordFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.6),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: _confirmPasswordFocused
                                              ? const Color(0xFFFF3D86)
                                              : theme.textTheme.bodyLarge?.color
                                              ?.withOpacity(0.4),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _confirmPasswordVisible
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: theme
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.4),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _confirmPasswordVisible =
                                              !_confirmPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF3D86),
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez confirmer le mot de passe';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Les mots de passe ne correspondent pas';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Checkbox CGU
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.2,
                                        child: Checkbox(
                                          value: _acceptTerms,
                                          onChanged: (value) {
                                            setState(() {
                                              _acceptTerms = value ?? false;
                                            });
                                          },
                                          activeColor: const Color(0xFFFF3D86),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _acceptTerms = !_acceptTerms;
                                            });
                                          },
                                          child: Text.rich(
                                            const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'J\'accepte les ',
                                                ),
                                                TextSpan(
                                                  text:
                                                  'conditions d\'utilisation',
                                                  style: TextStyle(
                                                    color: Color(
                                                      0xFFFF3D86,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 32),

                                  // Bouton inscription premium
                                  _PremiumButton(
                                    onPressed: isLoading ? null : _onSignUp,
                                    isLoading: isLoading,
                                    text: 'S\'inscrire',
                                  ),

                                  const SizedBox(height: 24),

                                  // Lien connexion harmonisé
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Déjà un compte ? ',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go('/sign-in'),
                                          child: const Text(
                                            'Se connecter',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF3D86),
                                              decoration:
                                              TextDecoration.underline,
                                              decorationColor: Color(
                                                0xFFFF3D86,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget bouton premium harmonisé
class _PremiumButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const _PremiumButton({
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton>
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
          child: GestureDetector(
            onTapDown: widget.onPressed != null
                ? (_) => _controller.forward()
                : null,
            onTapUp: widget.onPressed != null
                ? (_) => _controller.reverse()
                : null,
            onTapCancel: () => _controller.reverse(),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3D86), Color(0xFFFF6FA5)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3D86).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
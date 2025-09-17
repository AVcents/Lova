import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/domain/auth_state.dart';
import 'package:lova/features/auth/utils/email_validator.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _shakeController;
  late AnimationController _formController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _formSlideAnimation;
  late Animation<double> _formFadeAnimation;

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;
  int _failedAttempts = 0;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _emailFocused = false;
  bool _passwordFocused = false;

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

    // Démarrer l'animation du formulaire avec un petit délai
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    _formController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    HapticFeedback.lightImpact();

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      return;
    }

    final notifier = ref.read(authStateNotifierProvider.notifier);
    final res = await notifier.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (res.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie'),
            backgroundColor: Color(0xFF43A047),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          context.go('/dashboard');
        }
      }
    } else {
      setState(() {
        _failedAttempts++;
      });
      _shakeController.forward().then((_) => _shakeController.reverse());

      switch (res.errorType) {
        case AuthErrorType.userNotFound:
          setState(() => _emailError = 'Aucun compte trouvé avec cet email');
          break;
        case AuthErrorType.wrongPassword:
          setState(() {
            final restants = (5 - _failedAttempts).clamp(0, 5);
            _passwordError = restants < 5
                ? 'Mot de passe incorrect ($restants essais restants)'
                : 'Mot de passe incorrect';
          });
          break;
        case AuthErrorType.emailNotVerified:
          if (mounted) {
            context.go('/verify-email?email=${_emailController.text.trim()}');
          }
          break;
        case AuthErrorType.tooManyAttempts:
          _showErrorDialog(
            'Trop de tentatives',
            'Votre compte est temporairement bloqué. Réessayez plus tard.',
          );
          break;
        default:
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Erreur de connexion'),
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Compris',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateNotifierProvider);
    final isLoading = authState.maybeWhen(
      signingIn: () => true,
      orElse: () => false,
    );

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background statique avec dégradé
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
                                'Connexion',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Sous-titre
                              Text(
                                'Ravi de te revoir !',
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
                                  // Email field avec effet glow
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
                                      autofillHints: const [
                                        AutofillHints.email,
                                      ],
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
                                        errorText: _emailError,
                                        errorStyle: const TextStyle(
                                          color: Color(0xFFE53935),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'L\'email est requis';
                                        }
                                        final res = EmailValidator.validate(
                                          value.trim(),
                                        );
                                        if (!res.isValid) {
                                          return res.error ?? 'Email invalide';
                                        }
                                        if (res.suggestion != null &&
                                            res.suggestion !=
                                                value.trim().toLowerCase()) {
                                          return 'Vouliez-vous dire ${res.suggestion} ?';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Password field avec effet glow
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
                                      obscureText: !_isPasswordVisible,
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      style: const TextStyle(fontSize: 16),
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
                                            _isPasswordVisible
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
                                              _isPasswordVisible =
                                              !_isPasswordVisible;
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
                                        errorText: _passwordError,
                                        errorStyle: const TextStyle(
                                          color: Color(0xFFE53935),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Le mot de passe est requis';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _handleSignIn(),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Options avec design moderne
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (value) {
                                                setState(() {
                                                  _rememberMe = value ?? false;
                                                });
                                              },
                                              activeColor: const Color(
                                                0xFFFF3D86,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Se souvenir',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            context.go('/forgot-password'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFFFF3D86,
                                          ),
                                        ),
                                        child: const Text(
                                          'Mot de passe oublié ?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 32),

                                  // Bouton connexion premium avec animation
                                  _PremiumButton(
                                    onPressed: isLoading ? null : _handleSignIn,
                                    isLoading: isLoading,
                                    text: 'Se connecter',
                                  ),

                                  const SizedBox(height: 24),

                                  // Lien inscription mis en avant
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Pas encore de compte ? ',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go('/sign-up'),
                                          child: const Text(
                                            "S'inscrire",
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

// Widget personnalisé pour le bouton premium
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
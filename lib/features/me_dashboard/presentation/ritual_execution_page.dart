// lib/features/me_dashboard/presentation/ritual_execution_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:lova/features/me_dashboard/providers/me_providers.dart';
import 'package:lova/features/me_dashboard/presentation/rituals_selection_page.dart';

class RitualExecutionPage extends ConsumerStatefulWidget {
  final RitualType ritual;
  final int durationMinutes;

  const RitualExecutionPage({
    super.key,
    required this.ritual,
    required this.durationMinutes,
  });

  @override
  ConsumerState<RitualExecutionPage> createState() => _RitualExecutionPageState();
}

class _RitualExecutionPageState extends ConsumerState<RitualExecutionPage>
    with SingleTickerProviderStateMixin {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPaused = false;
  bool _showIntro = true;
  bool _isCompleting = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;

    // Empêcher l'écran de se mettre en veille
    WakelockPlus.enable();

    // Animation de pulsation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Afficher l'intro pendant 4 secondes puis démarrer
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showIntro = false);
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _onComplete();
      }
    });
  }

  void _pauseResume() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
        HapticFeedback.mediumImpact();
      } else {
        _startTimer();
        HapticFeedback.lightImpact();
      }
    });
  }

  Future<void> _finishNow() async {
    final actualMinutes = (((_totalSeconds - _remainingSeconds) / 60).ceil()).clamp(1, widget.durationMinutes);

    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Terminer maintenant ?'),
        content: Text(
          'Vous avez pratiqué environ $actualMinutes minute${actualMinutes > 1 ? 's' : ''}.\n\nVoulez-vous enregistrer ce temps ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuer'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: widget.ritual.color,
            ),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (shouldFinish == true && mounted) {
      await _completeRitual(actualMinutes);
    }
  }

  Future<void> _onComplete() async {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    // Animation de célébration
    setState(() => _isCompleting = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      await _completeRitual(widget.durationMinutes);
    }
  }

  Future<void> _completeRitual(int minutes) async {
    final notifier = ref.read(actionsNotifierProvider.notifier);
    final success = await notifier.createAction(
      type: widget.ritual.id,
      title: widget.ritual.title,
      durationMin: minutes,
    );

    if (!mounted) return;

    if (success) {
      ref.invalidate(todayRitualsMinutesProvider);
      ref.invalidate(weekMetricsProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('✨ ${widget.ritual.title} complété !')),
            ],
          ),
          backgroundColor: widget.ritual.color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = 1 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.ritual.color.withOpacity(0.15),
              colorScheme.surface,
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: _showIntro
              ? _buildIntroScreen(colorScheme, textTheme)
              : _buildTimerScreen(colorScheme, textTheme, progress),
        ),
      ),
    );
  }

  Widget _buildIntroScreen(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Close button
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône animée
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.ritual.color.withOpacity(0.3),
                          widget.ritual.color.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      widget.ritual.icon,
                      size: 80,
                      color: widget.ritual.color,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Titre
                Text(
                  widget.ritual.title,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  '${widget.durationMinutes} minutes',
                  style: textTheme.titleLarge?.copyWith(
                    color: widget.ritual.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

                // Section "Pourquoi"
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.psychology_outlined,
                            color: widget.ritual.color,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Pourquoi ?',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.ritual.benefits,
                        style: textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Indicateur de démarrage
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(widget.ritual.color),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Démarrage dans un instant...',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerScreen(ColorScheme colorScheme, TextTheme textTheme, double progress) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  final shouldExit = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text('Quitter ?'),
                      content: const Text('Votre progression sera perdue.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Continuer'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'Quitter',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldExit == true && mounted) {
                    context.pop();
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.ritual.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Pour centrer le titre
            ],
          ),
        ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minuteur circulaire
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cercle de progression
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          backgroundColor: colorScheme.outline.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(widget.ritual.color),
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      // Temps restant
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isPaused)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.pause,
                                    size: 16,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'En pause',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          Text(
                            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.ritual.color,
                              fontSize: 64,
                              letterSpacing: -2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'restantes',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Instructions contextuelles
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.ritual.instructions,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Boutons de contrôle
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Bouton principal Pause/Reprendre
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _pauseResume,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(
                    _isPaused ? 'Reprendre' : 'Pause',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.ritual.color,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bouton terminer maintenant
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _finishNow,
                  icon: const Icon(Icons.check),
                  label: const Text('Terminer maintenant'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
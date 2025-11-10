import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/models/couple_ritual.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/providers/couple_rituals_provider.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/data/couple_rituals_data.dart';

class CoupleRitualExecutionScreen extends ConsumerStatefulWidget {
  final CoupleRitual ritual;
  final int durationMinutes;

  const CoupleRitualExecutionScreen({
    Key? key,
    required this.ritual,
    required this.durationMinutes,
  }) : super(key: key);

  @override
  ConsumerState<CoupleRitualExecutionScreen> createState() =>
      _CoupleRitualExecutionScreenState();
}

class _CoupleRitualExecutionScreenState
    extends ConsumerState<CoupleRitualExecutionScreen>
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

    WakelockPlus.enable();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
    final actualMinutes = (((_totalSeconds - _remainingSeconds) / 60).ceil())
        .clamp(1, widget.durationMinutes);

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
              backgroundColor: CoupleRitualsData.getColorForRitual(widget.ritual.id),
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

    setState(() => _isCompleting = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      await _completeRitual(widget.durationMinutes);
    }
  }

  Future<void> _saveSession(int durationActual) async {
    try {
      final sb = Supabase.instance.client;
      final userId = sb.auth.currentUser?.id;

      if (userId == null) return;

      // Récupérer relation_id
      final memberResp = await sb
          .from('relation_members')
          .select('relation_id')
          .eq('user_id', userId)
          .limit(1)
          .single();

      final relationId = memberResp['relation_id'] as String;

      // Insérer session
      await sb.from('couple_ritual_sessions').insert({
        'relation_id': relationId,
        'ritual_id': widget.ritual.id,
        'completed_by': userId,
        'duration_actual_minutes': durationActual,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log l'erreur mais ne bloque pas l'UX
      debugPrint('Erreur lors de la sauvegarde de la session: $e');
    }
  }

  Future<void> _completeRitual(int minutes) async {
    // Sauvegarder la session dans Supabase
    await _saveSession(minutes);

    // Incrémenter le compteur local
    ref.read(coupleRitualsProvider.notifier).incrementCompletion(widget.ritual.id);

    final currentMinutes = ref.read(todayCoupleRitualsMinutesProvider);
    ref.read(todayCoupleRitualsMinutesProvider.notifier).state =
        currentMinutes + minutes;

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(widget.ritual.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${widget.ritual.title} complété ! +${widget.ritual.points} pts'),
            ),
          ],
        ),
        backgroundColor: CoupleRitualsData.getColorForRitual(widget.ritual.id),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    context.pop();
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
              CoupleRitualsData.getColorForRitual(widget.ritual.id).withOpacity(0.15),
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

  // ════════════════════════════════════════════════════════════
  // ÉCRAN INTRO
  // ════════════════════════════════════════════════════════════

  Widget _buildIntroScreen(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
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
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          CoupleRitualsData.getColorForRitual(widget.ritual.id).withOpacity(0.3),
                          CoupleRitualsData.getColorForRitual(widget.ritual.id).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Text(
                      widget.ritual.emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  widget.ritual.title,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  '${widget.durationMinutes} minutes',
                  style: textTheme.titleLarge?.copyWith(
                    color: CoupleRitualsData.getColorForRitual(widget.ritual.id),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

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
                            Icons.favorite_border,
                            color: CoupleRitualsData.getColorForRitual(widget.ritual.id),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Pourquoi ce rituel ?',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                            CoupleRitualsData.getColorForRitual(widget.ritual.id)),
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

  // ════════════════════════════════════════════════════════════
  // ÉCRAN MINUTEUR
  // ════════════════════════════════════════════════════════════

  Widget _buildTimerScreen(
      ColorScheme colorScheme, TextTheme textTheme, double progress) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showExitDialog(context, colorScheme),
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
              const SizedBox(width: 48),
            ],
          ),
        ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          backgroundColor: colorScheme.outline.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(
                              CoupleRitualsData.getColorForRitual(widget.ritual.id)),
                          strokeCap: StrokeCap.round,
                        ),
                      ),

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
                              color: CoupleRitualsData.getColorForRitual(widget.ritual.id),
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

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CoupleRitualsData.getColorForRitual(widget.ritual.id).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lightbulb_outline,
                          size: 20,
                          color: CoupleRitualsData.getColorForRitual(widget.ritual.id),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.ritual.instructions.map((step) => step['text'] as String? ?? '').join('\n'),
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
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
                    backgroundColor: CoupleRitualsData.getColorForRitual(widget.ritual.id),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _finishNow,
                  icon: const Icon(Icons.check),
                  label: const Text('Terminer maintenant'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: CoupleRitualsData.getColorForRitual(widget.ritual.id)),
                    foregroundColor: CoupleRitualsData.getColorForRitual(widget.ritual.id),
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

  // ════════════════════════════════════════════════════════════
  // DIALOGS
  // ════════════════════════════════════════════════════════════

  void _showExitDialog(BuildContext context, ColorScheme colorScheme) async {
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
  }
}
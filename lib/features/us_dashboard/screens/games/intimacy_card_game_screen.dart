import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/us_dashboard/providers/games_provider.dart';
import 'package:lova/features/us_dashboard/screens/games/widgets/intimacy_card_widget.dart';

class IntimacyCardGameScreen extends ConsumerStatefulWidget {
  const IntimacyCardGameScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<IntimacyCardGameScreen> createState() => _IntimacyCardGameScreenState();
}

class _IntimacyCardGameScreenState extends ConsumerState<IntimacyCardGameScreen> {
  bool _showSettings = false;
  bool _includeSpicy = true;

  @override
  void initState() {
    super.initState();
    // Démarrer le jeu au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentGameSessionProvider.notifier).startGame(
        'loova_intimacy',
        includeSpicy: _includeSpicy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentGameSessionProvider);
    final hasQuestions = session.questions.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A0B2E),
              Color(0xFF2E1A47),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Contenu principal
              if (hasQuestions) ...[
                Column(
                  children: [
                    // Header
                    _buildHeader(context, session),

                    // Carte principale
                    Expanded(
                      child: Center(
                        child: IntimacyCardWidget(
                          question: session.currentQuestion,
                          onSwipeLeft: () => _handleSwipe(context, ref),
                          onSwipeRight: () => _handleSwipe(context, ref),
                        ),
                      ),
                    ),

                    // Footer avec contrôles
                    _buildControls(context, ref, session),

                    const SizedBox(height: 20),
                  ],
                ),
              ] else
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),

              // Settings overlay
              if (_showSettings)
                _buildSettingsOverlay(context),
            ],
          ),
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // HEADER
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildHeader(BuildContext context, GameSession session) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton retour
              IconButton(
                onPressed: () => _showExitDialog(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),

              // Titre
              Column(
                children: [
                  const Text(
                    '💕',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LOOVA Intimité',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Bouton settings
              IconButton(
                onPressed: () => setState(() => _showSettings = true),
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: session.progress / session.total,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress text
          Text(
            '${session.progress} / ${session.total}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CONTRÔLES
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildControls(BuildContext context, WidgetRef ref, GameSession session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bouton précédent
          _buildControlButton(
            icon: Icons.arrow_back,
            color: Colors.white.withOpacity(0.3),
            onTap: session.currentIndex > 0
                ? () => ref.read(currentGameSessionProvider.notifier).previousQuestion()
                : null,
          ),

          // Bouton skip
          _buildControlButton(
            icon: Icons.close,
            color: const Color(0xFFFF6B9D),
            size: 60,
            onTap: () => _handleSwipe(context, ref),
          ),

          // Bouton suivant
          _buildControlButton(
            icon: Icons.arrow_forward,
            color: const Color(0xFF9C27B0),
            size: 60,
            onTap: () => _handleSwipe(context, ref),
          ),

          // Bouton mélanger
          _buildControlButton(
            icon: Icons.shuffle,
            color: Colors.white.withOpacity(0.3),
            onTap: () {
              ref.read(currentGameSessionProvider.notifier).startGame(
                'loova_intimacy',
                includeSpicy: _includeSpicy,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    double size = 50,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: onTap != null
              ? [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SETTINGS OVERLAY
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSettingsOverlay(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showSettings = false),
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2E1A47),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Paramètres',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Toggle questions épicées
                SwitchListTile(
                  title: const Text(
                    'Inclure les questions épicées',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Questions plus intenses et intimes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  value: _includeSpicy,
                  onChanged: (value) {
                    setState(() => _includeSpicy = value);
                    ref.read(currentGameSessionProvider.notifier).startGame(
                      'loova_intimacy',
                      includeSpicy: value,
                    );
                    setState(() => _showSettings = false);
                  },
                  activeColor: const Color(0xFFE91E63),
                ),

                const SizedBox(height: 16),

                // Bouton recommencer
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(currentGameSessionProvider.notifier).startGame(
                        'loova_intimacy',
                        includeSpicy: _includeSpicy,
                      );
                      setState(() => _showSettings = false);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recommencer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bouton fermer
                TextButton(
                  onPressed: () => setState(() => _showSettings = false),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ACTIONS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void _handleSwipe(BuildContext context, WidgetRef ref) {
    final session = ref.read(currentGameSessionProvider);

    if (session.hasNext) {
      ref.read(currentGameSessionProvider.notifier).nextQuestion();
    } else {
      // Fin du jeu
      _showEndDialog(context, ref);
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E1A47),
        title: const Text(
          'Quitter le jeu ?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Votre progression sera perdue',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              ref.read(currentGameSessionProvider.notifier).endGame();
              Navigator.pop(context);
              context.pop();
            },
            child: const Text(
              'Quitter',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E1A47),
        title: const Text(
          '🎉 Félicitations !',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vous avez complété toutes les cartes !',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '💕',
              style: TextStyle(fontSize: 60),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Terminer', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              ref.read(currentGameSessionProvider.notifier).startGame(
                'loova_intimacy',
                includeSpicy: _includeSpicy,
              );
              Navigator.pop(context);
            },
            child: const Text(
              'Rejouer',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
          ),
        ],
      ),
    );
  }
}
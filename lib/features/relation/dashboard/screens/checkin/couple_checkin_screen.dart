import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lova/features/relation/dashboard/providers/couple_checkin_provider.dart';
import 'package:lova/features/relation/dashboard/screens/checkin/widgets/emotion_selector.dart';
import 'package:lova/features/relation/dashboard/screens/checkin/widgets/scale_slider.dart';
import 'package:lova/features/relation/dashboard/models/emotion_type.dart';
import 'package:lova/features/relation/dashboard/screens/checkin/widgets/text_input_with_toggle.dart';

class CoupleCheckinScreen extends ConsumerStatefulWidget {
  const CoupleCheckinScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoupleCheckinScreen> createState() => _CoupleCheckinScreenState();
}

class _CoupleCheckinScreenState extends ConsumerState<CoupleCheckinScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isChecking = true;
  String? _errorMessage;

  // Réponses
  int _scoreConnection = 5;
  int _scoreSatisfaction = 5;
  int _scoreCommunication = 5;
  EmotionType _emotion = EmotionType.joyful;
  final TextEditingController _gratitudeController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();
  final TextEditingController _needController = TextEditingController();
  bool _gratitudeShared = false;
  bool _concernShared = false;
  bool _needShared = false;

  @override
  void initState() {
    super.initState();
    _runPreflight();
  }

  Future<void> _runPreflight() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final sb = Supabase.instance.client;
      final userId = sb.auth.currentUser?.id;

      if (userId == null) {
        if (!mounted) return;
        setState(() {
          _isChecking = false;
          _errorMessage = 'Tu dois être connecté pour faire un check-in';
        });
        return;
      }

      // Vérifier si check-in déjà fait aujourd'hui
      final today = DateTime.now().toIso8601String().split('T')[0];
      final existing = await sb
          .from('couple_checkins')
          .select('id')
          .eq('user_id', userId)
          .eq('checkin_date', today)
          .maybeSingle();

      if (!mounted) return;

      if (existing != null) {
        setState(() {
          _isChecking = false;
          _errorMessage = 'Tu as déjà fait ton check-in aujourd\'hui ! 🎉';
        });
      } else {
        setState(() {
          _isChecking = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _errorMessage = 'Erreur lors de la vérification : $e';
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _concernController.dispose();
    _gratitudeController.dispose();
    _needController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitCheckin();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitCheckin() async {
    try {
      await ref.read(coupleCheckinNotifierProvider.notifier).saveCheckin(
        scoreConnection: _scoreConnection,
        scoreSatisfaction: _scoreSatisfaction,
        scoreCommunication: _scoreCommunication,
        emotion: _emotion,
        concernText: _concernController.text.isEmpty ? null : _concernController.text,
        gratitudeText: _gratitudeController.text.isEmpty ? null : _gratitudeController.text,
        needText: _needController.text.isEmpty ? null : _needController.text,
        gratitudeShared: _gratitudeShared,
        concernShared: _concernShared,
        needShared: _needShared,
      );
      if (mounted) {
        context.go('/couple-checkin-results');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Check-in de couple',
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isChecking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✅', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/couple-checkin-results'),
                icon: const Icon(Icons.visibility),
                label: const Text('Voir mes résultats'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildProgressIndicator(),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: [
              _buildWelcomePage(),
              _buildEmotionPage(),
              _buildScorePage(
                title: 'Connexion',
                question: 'Comment te sens-tu connecté(e) à ton partenaire ?',
                emoji: '💞',
                value: _scoreConnection,
                onChanged: (value) => setState(() => _scoreConnection = value),
              ),
              _buildScorePage(
                title: 'Satisfaction',
                question: 'Es-tu satisfait(e) de votre relation ?',
                emoji: '😊',
                value: _scoreSatisfaction,
                onChanged: (value) => setState(() => _scoreSatisfaction = value),
              ),
              _buildScorePage(
                title: 'Communication',
                question: 'La communication est-elle fluide ?',
                emoji: '💬',
                value: _scoreCommunication,
                onChanged: (value) => setState(() => _scoreCommunication = value),
              ),
              _buildTextWithTogglePage(
                title: 'Gratitude',
                question: 'Pour quoi es-tu reconnaissant(e) aujourd\'hui ?',
                emoji: '🙏',
                controller: _gratitudeController,
                toggleLabel: 'Partager avec mon partenaire',
                isShared: _gratitudeShared,
                onSharedChanged: (value) => setState(() => _gratitudeShared = value),
                isOptional: true,
              ),
              _buildTextWithTogglePage(
                title: 'Préoccupation',
                question: 'Y a-t-il quelque chose qui te préoccupe ?',
                emoji: '🤔',
                controller: _concernController,
                toggleLabel: 'Partager avec mon partenaire',
                isShared: _concernShared,
                onSharedChanged: (value) => setState(() => _concernShared = value),
                isOptional: true,
              ),
              _buildTextWithTogglePage(
                title: 'Besoin',
                question: 'De quoi as-tu besoin aujourd\'hui ?',
                emoji: '💚',
                controller: _needController,
                toggleLabel: 'Partager avec mon partenaire',
                isShared: _needShared,
                onSharedChanged: (value) => setState(() => _needShared = value),
                isOptional: true,
              ),
            ],
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // WIDGETS DE PAGES
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '💕',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 24),
          Text(
            'Bienvenue au Check-in',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Prenons quelques minutes pour faire le point sur votre relation',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.timer_outlined, '5 minutes'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.lock_outline, 'Confidentiel'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.favorite_outline, '7 questions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildEmotionPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Comment te sens-tu aujourd\'hui ?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          EmotionSelector(
            selectedEmotion: _emotion,
            onEmotionSelected: (emotion) => setState(() => _emotion = emotion),
          ),
        ],
      ),
    );
  }

  Widget _buildScorePage({
    required String title,
    required String question,
    required String emoji,
    required int value,
    required Function(int) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 24),
          Text(
            question,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ScaleSlider(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithTogglePage({
    required String title,
    required String question,
    required String emoji,
    required TextEditingController controller,
    required String toggleLabel,
    required bool isShared,
    required Function(bool) onSharedChanged,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 24),
            Text(
              question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (isOptional) ...[
              const SizedBox(height: 8),
              Text(
                '(Optionnel)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
            const SizedBox(height: 32),
            TextInputWithToggle(
              controller: controller,
              hintText: 'Écris tes pensées ici...',
              toggleLabel: toggleLabel,
              isShared: isShared,
              onSharedChanged: onSharedChanged,
            ),
          ],
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // NAVIGATION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: List.generate(8, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 7 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Retour'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentPage == 7 ? 'Terminer' : 'Suivant'),
            ),
          ),
        ],
      ),
    );
  }
}
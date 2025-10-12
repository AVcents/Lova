import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/us_dashboard/providers/couple_checkin_provider.dart';
import 'package:lova/features/us_dashboard/screens/checkin/widgets/emotion_selector.dart';
import 'package:lova/features/us_dashboard/screens/checkin/widgets/scale_slider.dart';

class CoupleCheckinScreen extends ConsumerStatefulWidget {
  const CoupleCheckinScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoupleCheckinScreen> createState() => _CoupleCheckinScreenState();
}

class _CoupleCheckinScreenState extends ConsumerState<CoupleCheckinScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Réponses
  int _connectionScore = 5;
  int _satisfactionScore = 5;
  int _communicationScore = 5;
  String _emotionToday = '😊';
  final TextEditingController _whatWentWellController = TextEditingController();
  final TextEditingController _whatNeedsAttentionController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _whatWentWellController.dispose();
    _whatNeedsAttentionController.dispose();
    _gratitudeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 6) {
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
    await ref.read(coupleCheckinNotifierProvider.notifier).saveCheckin(
      connectionScore: _connectionScore,
      satisfactionScore: _satisfactionScore,
      communicationScore: _communicationScore,
      emotionToday: _emotionToday,
      whatWentWell: _whatWentWellController.text.isEmpty ? null : _whatWentWellController.text,
      whatNeedsAttention: _whatNeedsAttentionController.text.isEmpty ? null : _whatNeedsAttentionController.text,
      gratitudeNote: _gratitudeController.text.isEmpty ? null : _gratitudeController.text,
    );

    if (mounted) {
      // Navigation vers résultats
      context.go('/couple-checkin-results');
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
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // Questions (PageView)
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
                  value: _connectionScore,
                  onChanged: (value) => setState(() => _connectionScore = value),
                ),
                _buildScorePage(
                  title: 'Satisfaction',
                  question: 'Es-tu satisfait(e) de votre relation ?',
                  emoji: '😊',
                  value: _satisfactionScore,
                  onChanged: (value) => setState(() => _satisfactionScore = value),
                ),
                _buildScorePage(
                  title: 'Communication',
                  question: 'La communication est-elle fluide ?',
                  emoji: '💬',
                  value: _communicationScore,
                  onChanged: (value) => setState(() => _communicationScore = value),
                ),
                _buildTextPage(
                  title: 'Ce qui va bien',
                  question: 'Qu\'est-ce qui s\'est bien passé cette semaine ?',
                  emoji: '✨',
                  controller: _whatWentWellController,
                  isOptional: true,
                ),
                _buildTextPage(
                  title: 'Points d\'attention',
                  question: 'Y a-t-il quelque chose qui nécessite de l\'attention ?',
                  emoji: '🔍',
                  controller: _whatNeedsAttentionController,
                  isOptional: true,
                ),
              ],
            ),
          ),

          // Boutons navigation
          _buildNavigationButtons(),
        ],
      ),
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
          Text(
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
            selectedEmotion: _emotionToday,
            onEmotionSelected: (emotion) => setState(() => _emotionToday = emotion),
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
          Text(emoji, style: TextStyle(fontSize: 60)),
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

  Widget _buildTextPage({
    required String title,
    required String question,
    required String emoji,
    required TextEditingController controller,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 60)),
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
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Écris tes pensées ici...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
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
        children: List.generate(7, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 6 ? 8 : 0),
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
              child: Text(_currentPage == 6 ? 'Terminer' : 'Suivant'),
            ),
          ),
        ],
      ),
    );
  }
}
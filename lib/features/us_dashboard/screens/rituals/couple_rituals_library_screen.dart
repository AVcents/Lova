import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/us_dashboard/screens/rituals/models/couple_ritual.dart';
import 'package:lova/features/us_dashboard/screens/rituals/providers/couple_rituals_provider.dart';
import 'package:lova/features/us_dashboard/screens/rituals/couple_ritual_execution_screen.dart';
import 'package:lova/features/us_dashboard/screens/rituals/widgets/ritual_info_bottom_sheet.dart';
import 'package:lova/features/us_dashboard/screens/rituals/data/couple_rituals_data.dart';

class CoupleRitualsLibraryScreen extends ConsumerStatefulWidget {
  const CoupleRitualsLibraryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoupleRitualsLibraryScreen> createState() =>
      _CoupleRitualsLibraryScreenState();
}

class _CoupleRitualsLibraryScreenState
    extends ConsumerState<CoupleRitualsLibraryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ritualsAsync = ref.watch(coupleRitualsProvider);
    final todayMinutes = ref.watch(todayCoupleRitualsMinutesProvider);

    final rituals = ritualsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <CoupleRitual>[],
    );

    // Filtrer par catégorie
    final filteredRituals = _selectedCategory == 'all'
        ? rituals
        : rituals.where((r) => r.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, colorScheme, textTheme),

            // Progress info
            _buildProgressCard(context, todayMinutes, colorScheme, textTheme),

            // Filtres par catégorie
            _buildCategoryFilters(context, colorScheme),

            // Liste des rituels
            Expanded(
              child: FadeTransition(
                opacity: _animationController,
                child: _buildRitualsList(
                  context,
                  filteredRituals,
                  colorScheme,
                  textTheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rituels de couple',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Renforcez votre connexion ensemble',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PROGRESS CARD
  // ═══════════════════════════════════════════════════════════

  Widget _buildProgressCard(
    BuildContext context,
    int todayMinutes,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.15),
            const Color(0xFFFFA06B).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text('💕', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$todayMinutes',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF6B9D),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'min ensemble aujourd\'hui',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Continuez comme ça ! 🎯',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FILTRES CATÉGORIES
  // ═══════════════════════════════════════════════════════════

  Widget _buildCategoryFilters(BuildContext context, ColorScheme colorScheme) {
    final categories = [
      {'id': 'all', 'label': 'Tous', 'emoji': '💫'},
      {'id': 'intimité', 'label': 'Intimité', 'emoji': '💋'},
      {'id': 'connexion', 'label': 'Connexion', 'emoji': '💬'},
      {'id': 'activité', 'label': 'Activités', 'emoji': '🎯'},
      {'id': 'bien-être', 'label': 'Bien-être', 'emoji': '🧘'},
      {'id': 'fun', 'label': 'Fun', 'emoji': '🎉'},
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedCategory = category['id'] as String);
            },
            child: Container(
              margin: EdgeInsets.only(right: index < categories.length - 1 ? 12 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6B9D) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF6B9D)
                      : colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Text(
                    category['emoji'] as String,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // LISTE RITUELS
  // ═══════════════════════════════════════════════════════════

  Widget _buildRitualsList(
    BuildContext context,
    List<CoupleRitual> rituals,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Trier : favoris d'abord
    final sortedRituals = [...rituals]..sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: sortedRituals.length,
      itemBuilder: (context, index) {
        final ritual = sortedRituals[index];

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _RitualCard(
              ritual: ritual,
              onTap: () => _startRitual(context, ritual),
              onInfoTap: () => _showRitualInfo(context, ritual),
              onFavoriteTap: () {
                HapticFeedback.lightImpact();
                ref.read(coupleRitualsProvider.notifier).toggleFavorite(ritual.id);
              },
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════

  void _startRitual(BuildContext context, CoupleRitual ritual) {
    if (ritual.isPremium) {
      _showPremiumDialog(context, ritual);
      return;
    }

    HapticFeedback.lightImpact();
    _showDurationSelector(context, ritual);
  }

  void _showDurationSelector(BuildContext context, CoupleRitual ritual) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DurationSelectorSheet(
        ritual: ritual,
        onDurationSelected: (duration) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoupleRitualExecutionScreen(
                ritual: ritual,
                durationMinutes: duration,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRitualInfo(BuildContext context, CoupleRitual ritual) {
    RitualInfoBottomSheet.show(context, ritual);
  }

  void _showPremiumDialog(BuildContext context, CoupleRitual ritual) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('👑'),
            const SizedBox(width: 8),
            Text(
              'Premium',
              style: TextStyle(
                color: CoupleRitualsData.getColorForRitual(ritual.id),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ritual.emoji} ${ritual.title}'),
            const SizedBox(height: 12),
            const Text(
              'Ce rituel est réservé aux membres Premium.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ Avec Premium :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text('• Tous les rituels débloqués', style: TextStyle(fontSize: 12)),
                  Text('• Créez vos propres rituels', style: TextStyle(fontSize: 12)),
                  Text('• Rappels personnalisés', style: TextStyle(fontSize: 12)),
                  Text('• Statistiques avancées', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Plus tard'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigation vers Premium
            },
            style: FilledButton.styleFrom(backgroundColor: CoupleRitualsData.getColorForRitual(ritual.id)),
            child: const Text('Découvrir Premium'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// RITUAL CARD
// ═══════════════════════════════════════════════════════════

class _RitualCard extends StatelessWidget {
  final CoupleRitual ritual;
  final VoidCallback onTap;
  final VoidCallback onInfoTap;
  final VoidCallback onFavoriteTap;

  const _RitualCard({
    required this.ritual,
    required this.onTap,
    required this.onInfoTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Emoji + Lock
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            ritual.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      if (ritual.isPremium)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: CoupleRitualsData.getColorForRitual(ritual.id),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                ritual.title,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onFavoriteTap,
                              icon: Icon(
                                ritual.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: ritual.isFavorite
                                    ? CoupleRitualsData.getColorForRitual(ritual.id)
                                    : colorScheme.onSurface.withOpacity(0.4),
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ritual.description,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Footer
              Row(
                children: [
                  // Catégorie
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ritual.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CoupleRitualsData.getColorForRitual(ritual.id),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Durée
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${ritual.defaultDuration} min',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats si complété
                  if (ritual.timesCompleted > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('✓', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Text(
                            '${ritual.timesCompleted}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Bouton info
                  IconButton(
                    onPressed: onInfoTap,
                    icon: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: CoupleRitualsData.getColorForRitual(ritual.id),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// DURATION SELECTOR SHEET
// ═══════════════════════════════════════════════════════════

class _DurationSelectorSheet extends StatelessWidget {
  final CoupleRitual ritual;
  final Function(int) onDurationSelected;

  const _DurationSelectorSheet({
    required this.ritual,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(ritual.emoji, style: const TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 20),
          Text(
            ritual.title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Choisissez une durée',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...ritual.durationOptions.map((duration) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => onDurationSelected(duration),
                    style: FilledButton.styleFrom(
                      backgroundColor: CoupleRitualsData.getColorForRitual(ritual.id),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '$duration minutes',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
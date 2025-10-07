// lib/features/me_dashboard/presentation/rituals_selection_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/me_dashboard/providers/me_providers.dart';
import 'package:lova/features/me_dashboard/presentation/widgets/ritual_info_bottom_sheet.dart';
import 'package:lova/features/me_dashboard/presentation/ritual_execution_page.dart';

class RitualsSelectionPage extends ConsumerStatefulWidget {
  const RitualsSelectionPage({super.key});

  @override
  ConsumerState<RitualsSelectionPage> createState() => _RitualsSelectionPageState();
}

class _RitualsSelectionPageState extends ConsumerState<RitualsSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const List<RitualType> rituals = [
    RitualType(
      id: 'respiration',
      title: 'Respiration',
      description: 'Exercice de respiration guidée',
      icon: Icons.air,
      defaultDuration: 5,
      color: Color(0xFF4CAF50),
      benefits: 'La respiration consciente active le système nerveux parasympathique, réduisant immédiatement le stress et l\'anxiété. Elle améliore l\'oxygénation du cerveau et aide à retrouver son calme en quelques minutes.',
      benefitsList: [
        'Réduit rapidement le stress et l\'anxiété',
        'Améliore la concentration et la clarté mentale',
        'Régule la fréquence cardiaque',
        'Aide à gérer les émotions difficiles',
      ],
      instructions: 'Inspirez profondément par le nez pendant 4 secondes, retenez 4 secondes, expirez lentement par la bouche pendant 6 secondes. Répétez ce cycle en vous concentrant sur votre souffle.',
      howTo: 'Installez-vous confortablement, dos droit. Fermez les yeux ou fixez un point devant vous. Respirez naturellement quelques instants, puis commencez la technique 4-4-6 : inspiration nasale (4s), rétention (4s), expiration buccale (6s). Laissez vos pensées passer sans vous y attacher.',
      recommendedFrequency: '2-3 fois par jour, surtout en cas de stress',
      durationOptions: [3, 5, 10],
    ),
    RitualType(
      id: 'meditation',
      title: 'Méditation',
      description: 'Moment de pleine conscience',
      icon: Icons.self_improvement,
      defaultDuration: 10,
      color: Color(0xFF9C27B0),
      benefits: 'La méditation régulière réduit le stress, améliore la concentration et favorise le bien-être émotionnel. Elle aide à développer une meilleure conscience de soi et à prendre du recul sur les situations difficiles.',
      benefitsList: [
        'Diminue le stress et l\'anxiété de façon durable',
        'Améliore la concentration et la mémoire',
        'Favorise la régulation émotionnelle',
        'Développe la bienveillance envers soi-même',
      ],
      instructions: 'Asseyez-vous confortablement, dos droit. Fermez les yeux et portez votre attention sur votre respiration. Quand votre esprit s\'égare, ramenez doucement votre attention au souffle.',
      howTo: 'Choisissez un endroit calme. Asseyez-vous en tailleur ou sur une chaise, dos droit mais détendu. Fermez les yeux et concentrez-vous sur les sensations de la respiration. Quand des pensées arrivent (c\'est normal), observez-les sans jugement et revenez à votre respiration.',
      recommendedFrequency: '10-20 minutes par jour, idéalement le matin',
      durationOptions: [5, 10, 15, 20],
    ),
    RitualType(
      id: 'gratitude',
      title: 'Gratitude',
      description: 'Noter 3 choses positives',
      icon: Icons.favorite_border,
      defaultDuration: 5,
      color: Color(0xFFFF9800),
      benefits: 'Pratiquer la gratitude régulièrement améliore significativement le bien-être mental et l\'humeur. Cela aide à reprogrammer le cerveau pour remarquer le positif plutôt que de se concentrer uniquement sur les problèmes.',
      benefitsList: [
        'Augmente le sentiment de bonheur',
        'Améliore la qualité du sommeil',
        'Renforce les relations sociales',
        'Réduit les symptômes dépressifs',
      ],
      instructions: 'Prenez un moment pour réfléchir à trois choses pour lesquelles vous êtes reconnaissant aujourd\'hui. Peuvent être grandes ou petites, importantes ou simples.',
      howTo: 'Installez-vous confortablement avec un carnet ou utilisez l\'app. Pensez à votre journée et identifiez trois moments, personnes ou choses qui vous ont apporté de la joie, du réconfort ou de l\'aide. Notez-les en quelques mots, en ressentant vraiment la gratitude.',
      recommendedFrequency: 'Une fois par jour, idéalement le soir',
      durationOptions: [3, 5],
    ),
    RitualType(
      id: 'lecture',
      title: 'Lecture',
      description: 'Temps de lecture',
      icon: Icons.menu_book,
      defaultDuration: 15,
      color: Color(0xFF2196F3),
      benefits: 'La lecture régulière améliore les fonctions cognitives, réduit le stress et favorise l\'empathie. Elle permet de s\'évader du quotidien tout en stimulant l\'imagination et l\'apprentissage.',
      benefitsList: [
        'Réduit le stress de 68% en seulement 6 minutes',
        'Améliore les capacités cognitives et la mémoire',
        'Favorise l\'empathie et la compréhension d\'autrui',
        'Améliore la qualité du sommeil',
      ],
      instructions: 'Installez-vous confortablement dans un endroit calme. Choisissez une lecture qui vous plaît et plongez-vous dedans sans distractions.',
      howTo: 'Éteignez vos notifications. Trouvez un endroit confortable et bien éclairé. Choisissez un livre, article ou contenu qui vous intéresse vraiment. Lisez à votre rythme, sans pression. L\'objectif est le plaisir et la détente.',
      recommendedFrequency: '15-30 minutes par jour',
      durationOptions: [10, 15, 20, 30],
    ),
    RitualType(
      id: 'marche',
      title: 'Marche',
      description: 'Sortir prendre l\'air',
      icon: Icons.directions_walk,
      defaultDuration: 20,
      color: Color(0xFF00BCD4),
      benefits: 'La marche régulière améliore la santé cardiovasculaire, booste l\'humeur et réduit l\'anxiété. Elle permet aussi de se reconnecter avec son environnement et de clarifier ses pensées.',
      benefitsList: [
        'Améliore l\'humeur et réduit les symptômes dépressifs',
        'Boost la créativité et la résolution de problèmes',
        'Renforce le système cardiovasculaire',
        'Favorise la production d\'endorphines',
      ],
      instructions: 'Marchez à un rythme confortable, en portant attention à votre environnement. Respirez profondément et laissez vos pensées se clarifier naturellement.',
      howTo: 'Sortez dehors, dans un parc ou votre quartier. Marchez d\'un pas régulier, sans vous presser. Observez ce qui vous entoure, les sons, les odeurs. Si vous avez des préoccupations, laissez-les venir et partir naturellement pendant que vous marchez.',
      recommendedFrequency: '20-30 minutes par jour',
      durationOptions: [10, 20, 30],
    ),
    RitualType(
      id: 'etirement',
      title: 'Étirement',
      description: 'Étirements doux',
      icon: Icons.accessibility_new,
      defaultDuration: 10,
      color: Color(0xFFE91E63),
      benefits: 'Les étirements réguliers réduisent les tensions musculaires, améliorent la posture et la flexibilité. Ils favorisent aussi la circulation sanguine et aident à prévenir les douleurs.',
      benefitsList: [
        'Réduit les tensions et douleurs musculaires',
        'Améliore la flexibilité et la posture',
        'Favorise la circulation sanguine',
        'Aide à prévenir les blessures',
      ],
      instructions: 'Réalisez des étirements doux sans forcer. Maintenez chaque position 20-30 secondes en respirant profondément.',
      howTo: 'Trouvez un espace dégagé. Commencez par le cou et les épaules, descendez progressivement vers le dos, les jambes. Étirez en douceur jusqu\'à sentir une légère tension, jamais de douleur. Respirez profondément dans chaque position. Maintenez 20-30 secondes.',
      recommendedFrequency: '10-15 minutes par jour',
      durationOptions: [5, 10, 15],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
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
    final minutesAsync = ref.watch(todayRitualsMinutesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mes rituels'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: minutesAsync.when(
        data: (usedMinutes) {
          final remainingMinutes = 30 - usedMinutes;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildProgressHeader(
                  context,
                  usedMinutes,
                  remainingMinutes,
                  colorScheme,
                  textTheme,
                ),
                Expanded(
                  child: remainingMinutes <= 0
                      ? _buildEmptyState(context, colorScheme, textTheme)
                      : _buildRitualsList(
                    context,
                    remainingMinutes,
                    colorScheme,
                    textTheme,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(
      BuildContext context,
      int usedMinutes,
      int remainingMinutes,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    final progress = usedMinutes / 30;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: colorScheme.outline.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$remainingMinutes',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          'min',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      remainingMinutes > 0
                          ? 'Temps restant aujourd\'hui'
                          : 'Objectif quotidien atteint !',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$usedMinutes min utilisées',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Objectif : 30 min/jour',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (usedMinutes > 0) ...[
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: colorScheme.outline.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRitualsList(
      BuildContext context,
      int remainingMinutes,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: rituals.length + 1,
      itemBuilder: (context, index) {
        if (index == rituals.length) {
          return _buildMotivationCard(context, colorScheme, textTheme);
        }

        final ritual = rituals[index];
        final canDo = ritual.defaultDuration <= remainingMinutes;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _RitualCard(
              ritual: ritual,
              enabled: canDo,
              onTap: canDo ? () => _startRitual(context, ref, ritual) : null,
              onInfoTap: () => RitualInfoBottomSheet.show(context, ritual),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotivationCard(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiaryContainer.withOpacity(0.3),
            colorScheme.primaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.spa,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pourquoi les rituels ?',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Les rituels quotidiens créent des habitudes positives et améliorent votre bien-être mental et physique.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.15),
                    Colors.green.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.celebration,
                size: 80,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Bravo !',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vous avez atteint votre objectif quotidien de 30 minutes de rituels',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Revenez demain pour continuer',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => context.pop(),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }

  void _startRitual(BuildContext context, WidgetRef ref, RitualType ritual) {
    HapticFeedback.lightImpact();

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
              builder: (context) => RitualExecutionPage(
                ritual: ritual,
                durationMinutes: duration,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RitualCard extends StatelessWidget {
  final RitualType ritual;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback onInfoTap;

  const _RitualCard({
    required this.ritual,
    required this.enabled,
    this.onTap,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled
              ? () {
            HapticFeedback.lightImpact();
            onTap?.call();
          }
              : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: enabled
                    ? ritual.color.withOpacity(0.3)
                    : colorScheme.outline.withOpacity(0.2),
                width: enabled ? 2 : 1,
              ),
              boxShadow: enabled
                  ? [
                BoxShadow(
                  color: ritual.color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ritual.color.withOpacity(0.2),
                        ritual.color.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    ritual.icon,
                    color: ritual.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
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
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: ritual.color,
                            ),
                            onPressed: onInfoTap,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ritual.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ritual.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: ritual.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${ritual.defaultDuration}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ritual.color,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'min',
                            style: textTheme.bodySmall?.copyWith(
                              color: ritual.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!enabled) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Insuffisant',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationSelectorSheet extends StatelessWidget {
  final RitualType ritual;
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
              gradient: LinearGradient(
                colors: [
                  ritual.color.withOpacity(0.2),
                  ritual.color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              ritual.icon,
              color: ritual.color,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            ritual.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                  backgroundColor: ritual.color,
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

class RitualType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int defaultDuration;
  final Color color;
  final String benefits;
  final List<String> benefitsList;
  final String instructions;
  final String howTo;
  final String recommendedFrequency;
  final List<int> durationOptions;

  const RitualType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.defaultDuration,
    required this.color,
    required this.benefits,
    required this.benefitsList,
    required this.instructions,
    required this.howTo,
    required this.recommendedFrequency,
    required this.durationOptions,
  });
}
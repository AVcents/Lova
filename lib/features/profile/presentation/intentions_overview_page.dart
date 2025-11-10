// lib/features/profile/presentation/intentions_overview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/profile/data/models/life_intention_model.dart';
import 'package:lova/features/profile/providers/intentions_providers.dart';
import 'package:lova/features/profile/presentation/widgets/intention_card.dart';

class IntentionsOverviewPage extends ConsumerStatefulWidget {
  const IntentionsOverviewPage({super.key});

  @override
  ConsumerState<IntentionsOverviewPage> createState() => _IntentionsOverviewPageState();
}

class _IntentionsOverviewPageState extends ConsumerState<IntentionsOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Archiver les intentions expirées au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(intentionsNotifierProvider.notifier).archiveExpired();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Mes Intentions'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Complétées'),
            Tab(text: 'Archives'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(context, ref),
          _buildCompletedTab(context, ref),
          _buildArchivedTab(context, ref),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push('/intentions/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle intention'),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Widget _buildActiveTab(BuildContext context, WidgetRef ref) {
    final activeIntentionsAsync = ref.watch(activeIntentionsProvider);

    return activeIntentionsAsync.when(
      data: (intentions) {
        if (intentions.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.auto_awesome,
            title: 'Aucune intention active',
            subtitle: 'Commencez par définir votre première intention',
            actionLabel: 'Créer une intention',
            onAction: () => context.push('/intentions/create'),
          );
        }

        // Grouper par type
        final monthly = intentions.where((i) => i.type == IntentionType.monthly).toList();
        final seasonal = intentions.where((i) => i.type == IntentionType.seasonal).toList();
        final ongoing = intentions.where((i) => i.type == IntentionType.ongoing).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats en haut
              _buildStatsCard(context, ref),

              const SizedBox(height: 20),

              // Mensuelles
              if (monthly.isNotEmpty) ...[
                _buildSectionHeader(context, 'Ce mois', monthly.length, 3),
                const SizedBox(height: 12),
                ...monthly.map((intention) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IntentionCard(intention: intention),
                )),
                const SizedBox(height: 20),
              ],

              // Saisonnières
              if (seasonal.isNotEmpty) ...[
                _buildSectionHeader(context, 'Cette saison', seasonal.length, 2),
                const SizedBox(height: 12),
                ...seasonal.map((intention) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IntentionCard(intention: intention),
                )),
                const SizedBox(height: 20),
              ],

              // Sans limite
              if (ongoing.isNotEmpty) ...[
                _buildSectionHeader(context, 'Sans limite', ongoing.length, 2),
                const SizedBox(height: 12),
                ...ongoing.map((intention) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IntentionCard(intention: intention),
                )),
              ],

              const SizedBox(height: 80), // Espace pour FAB
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Erreur de chargement', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTab(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(
      intentionsByStatusProvider(IntentionStatus.completed),
    );

    return completedAsync.when(
      data: (intentions) {
        if (intentions.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.celebration,
            title: 'Aucune intention complétée',
            subtitle: 'Vos intentions complétées apparaîtront ici',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: intentions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return IntentionCard(intention: intentions[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erreur')),
    );
  }

  Widget _buildArchivedTab(BuildContext context, WidgetRef ref) {
    final archivedAsync = ref.watch(
      intentionsByStatusProvider(IntentionStatus.archived),
    );

    return archivedAsync.when(
      data: (intentions) {
        if (intentions.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.archive_outlined,
            title: 'Aucune archive',
            subtitle: 'Les intentions expirées ou archivées apparaîtront ici',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: intentions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return IntentionCard(intention: intentions[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erreur')),
    );
  }

  Widget _buildStatsCard(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(intentionsStatsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return statsAsync.when(
      data: (stats) {
        final total = stats['total'] as int? ?? 0;
        final active = stats['active'] as int? ?? 0;
        final completed = stats['completed'] as int? ?? 0;
        final completionRate = stats['completion_rate'] as int? ?? 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer.withOpacity(0.3),
                colorScheme.secondaryContainer.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre progression',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatItem(
                    context,
                    '$active',
                    'Actives',
                    Icons.bolt,
                    colorScheme.primary,
                  ),
                  const SizedBox(width: 20),
                  _buildStatItem(
                    context,
                    '$completed',
                    'Complétées',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(width: 20),
                  _buildStatItem(
                    context,
                    '$completionRate%',
                    'Taux',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      Color color,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context,
      String title,
      int count,
      int max,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count/$max',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        String? actionLabel,
        VoidCallback? onAction,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
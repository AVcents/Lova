import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lova/features/metrics/gauge_provider.dart';

class UsDashboardView extends ConsumerWidget {
  const UsDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gaugeInt = ref.watch(gaugeProvider);
    final gauge = gaugeInt.toDouble();

    // Simulation d'une tendance
    final trend = gauge > 75 ? 1 : (gauge > 50 ? 0 : -1);
    final trendIcon = trend > 0
        ? Icons.trending_up
        : trend < 0
        ? Icons.trending_down
        : Icons.trending_flat;
    final trendColor = trend > 0
        ? Colors.green
        : trend < 0
        ? Colors.orange
        : colorScheme.onSurface.withOpacity(0.6);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Carte héro - Jauge relation
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Gradient décoratif subtil
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFFA12539).withOpacity(0.1),
                                const Color(0xFFFF5A6E).withOpacity(0.1),
                              ]
                            : [
                                const Color(0xFFFFA38F).withOpacity(0.08),
                                const Color(0xFFFF6FA5).withOpacity(0.08),
                              ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'État de notre relation',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Jauge circulaire
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: gauge / 100,
                                strokeWidth: 10,
                                backgroundColor: colorScheme.onSurface
                                    .withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getGaugeColor(gauge, colorScheme),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: _getGaugeColor(gauge, colorScheme),
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${gauge.toInt()}%',
                                  style: textTheme.headlineMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _getGaugeLabel(gauge),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tendance
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(trendIcon, color: trendColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              trend > 0
                                  ? '+${(gauge * 0.05).toStringAsFixed(1)}% vs 7j'
                                  : trend < 0
                                  ? '${(gauge * -0.03).toStringAsFixed(1)}% vs 7j'
                                  : 'Stable vs 7j',
                              style: textTheme.bodyMedium?.copyWith(
                                color: trendColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CTA Principal
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Text(
              'Conseil du jour pour nous',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.favorite_outline,
                  label: 'Attention',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/library-us');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.calendar_today,
                  label: 'Planifier',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  icon: Icons.healing,
                  label: 'SOS',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Sections historiques (comme ME dashboard)
          Row(
            children: [
              Expanded(
                child: _HistorySection(
                  icon: Icons.favorite,
                  title: 'Check-ins',
                  subtitle: 'Historique couple',
                  onTap: () => context.push('/couple-checkin-history'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:_HistorySection(
                  icon: Icons.self_improvement,
                  title: 'Rituels',
                  subtitle: 'Bientôt disponible',
                  onTap: null, // Disabled pour l'instant
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HistorySection(
                  icon: Icons.menu_book,
                  title: 'Journal partagé',
                  subtitle: 'Bientôt disponible',
                  onTap: null, // Disabled pour l'instant
                ),
              ),
              const SizedBox(width: 12),
              const Spacer(), // Pour équilibrer
            ],
          ),

          const SizedBox(height: 20),

          // Section Moments à venir
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event, color: colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Moments à venir',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // État vide élégant
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.event_available,
                          color: colorScheme.primary.withOpacity(0.5),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun moment planifié',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Créez votre premier moment ensemble',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        icon: Icon(
                          Icons.add,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          'Planifier un moment',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGaugeColor(double gauge, ColorScheme colorScheme) {
    if (gauge >= 80) return Colors.green;
    if (gauge >= 60) return colorScheme.primary;
    if (gauge >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getGaugeLabel(double gauge) {
    if (gauge >= 80) return 'Excellente';
    if (gauge >= 60) return 'Bonne';
    if (gauge >= 40) return 'À améliorer';
    return 'Attention requise';
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _HistorySection({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = onTap == null;

    return Card(
      elevation: 0,
      color: isDisabled ? Colors.grey.shade100 : colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: isDisabled ? Colors.grey : colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDisabled
                      ? Colors.grey.shade600
                      : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: isDisabled
                      ? Colors.grey.shade500
                      : colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

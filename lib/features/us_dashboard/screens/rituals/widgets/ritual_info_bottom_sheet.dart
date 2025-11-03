import 'package:flutter/material.dart';
import 'package:lova/features/us_dashboard/screens/rituals/models/couple_ritual.dart';
import 'package:lova/features/us_dashboard/screens/rituals/data/couple_rituals_data.dart';

class RitualInfoBottomSheet extends StatelessWidget {
  final CoupleRitual ritual;

  const RitualInfoBottomSheet({
    Key? key,
    required this.ritual,
  }) : super(key: key);

  static void show(BuildContext context, CoupleRitual ritual) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RitualInfoBottomSheet(ritual: ritual),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          ritual.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ritual.title,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ritual.description,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Bénéfices
                  _buildSection(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Pourquoi pratiquer ?',
                    content: ritual.benefits,
                    color: CoupleRitualsData.getColorForRitual(ritual.id),
                  ),

                  const SizedBox(height: 24),

                  // Instructions
                  _buildSection(
                    context,
                    icon: Icons.lightbulb_outline,
                    title: 'Comment faire ?',
                    content: ritual.instructions.map((step) => step['text'] as String? ?? '').join('\n'),
                    color: CoupleRitualsData.getColorForRitual(ritual.id),
                  ),

                  const SizedBox(height: 24),

                  // Tips
                  _buildSection(
                    context,
                    icon: Icons.tips_and_updates_outlined,
                    title: 'Conseils',
                    content: ritual.tips,
                    color: CoupleRitualsData.getColorForRitual(ritual.id),
                  ),

                  const SizedBox(height: 24),

                  // Points & Catégorie
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CoupleRitualsData.getColorForRitual(ritual.id).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${ritual.points}',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CoupleRitualsData.getColorForRitual(ritual.id),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'points',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                ritual.category,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CoupleRitualsData.getColorForRitual(ritual.id),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'catégorie',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Bouton
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: CoupleRitualsData.getColorForRitual(ritual.id),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Compris !',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
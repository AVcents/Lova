// lib/features/profile/presentation/widgets/ritual_info_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:lova/features/profile/presentation/rituals_selection_page.dart';

class RitualInfoBottomSheet extends StatelessWidget {
  final RitualType ritual;

  const RitualInfoBottomSheet({
    super.key,
    required this.ritual,
  });

  static void show(BuildContext context, RitualType ritual) {
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
                  // Header avec icône
                  Row(
                    children: [
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
                          size: 32,
                          color: ritual.color,
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

                  // Section "Pourquoi ?"
                  _buildSection(
                    context,
                    icon: Icons.psychology_outlined,
                    title: 'Pourquoi pratiquer ?',
                    content: ritual.benefits,
                    color: ritual.color,
                  ),

                  const SizedBox(height: 24),

                  // Section "Bénéfices"
                  _buildSection(
                    context,
                    icon: Icons.favorite_outline,
                    title: 'Bénéfices principaux',
                    color: ritual.color,
                    bulletPoints: ritual.benefitsList,
                  ),

                  const SizedBox(height: 24),

                  // Section "Comment faire"
                  _buildSection(
                    context,
                    icon: Icons.tips_and_updates_outlined,
                    title: 'Conseils de pratique',
                    content: ritual.howTo,
                    color: ritual.color,
                  ),

                  const SizedBox(height: 24),

                  // Fréquence recommandée
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ritual.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ritual.color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: ritual.color,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fréquence recommandée',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ritual.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ritual.recommendedFrequency,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bouton de fermeture
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: ritual.color,
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
        String? content,
        List<String>? bulletPoints,
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
        const SizedBox(height: 16),
        if (content != null)
          Text(
            content,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        if (bulletPoints != null)
          ...bulletPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    point,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
}
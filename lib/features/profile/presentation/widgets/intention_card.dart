// lib/features/profile/presentation/widgets/intention_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:lova/features/profile/data/models/life_intention_model.dart';
import 'package:lova/features/profile/providers/intentions_providers.dart';
import 'package:lova/features/profile/presentation/widgets/intention_progress_ring.dart';

class IntentionCard extends ConsumerWidget {
  final LifeIntention intention;
  final VoidCallback? onTap;

  const IntentionCard({
    super.key,
    required this.intention,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) {
          onTap!();
        } else {
          context.push('/intentions/detail/${intention.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
                // Emoji catégorie
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    intention.category.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),

                // Titre et catégorie
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intention.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${intention.category.label} · ${intention.type.label}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cercle de progression (si trackable)
                if (intention.isTrackable)
                  IntentionProgressRing(
                    progress: intention.progressPercentage,
                    size: 50,
                    strokeWidth: 5,
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Progrès textuel
            if (intention.isTrackable) ...[
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: intention.progressPercentage,
                      minHeight: 6,
                      backgroundColor: colorScheme.outline.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    intention.progressText,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Dernière activité / date limite
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  intention.daysRemaining != null
                      ? 'Il reste ${intention.daysRemaining} jour${intention.daysRemaining! > 1 ? 's' : ''}'
                      : 'Sans limite de temps',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const Spacer(),

                // Bouton +1 rapide
                if (intention.isTrackable)
                  SizedBox(
                    height: 32,
                    child: FilledButton(
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        final notifier = ref.read(intentionsNotifierProvider.notifier);
                        await notifier.addProgress(intentionId: intention.id);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: colorScheme.primary,
                      ),
                      child: const Text(
                        '+1',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
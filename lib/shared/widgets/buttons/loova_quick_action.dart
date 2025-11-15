// lib/shared/widgets/buttons/loova_quick_action.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Bouton d'action rapide LOOVA
///
/// Bouton carré avec icône + label, utilisé dans les grilles d'actions rapides.
/// Supporte un badge de notification optionnel.
///
/// Usage :
/// ```dart
/// // Action simple
/// LoovaQuickAction(
///   icon: Icons.check_circle_outline,
///   label: 'Check-in',
///   onTap: () => context.pushNamed('checkin'),
/// )
///
/// // Action avec notification
/// LoovaQuickAction(
///   icon: Icons.notifications,
///   label: 'Notifications',
///   hasNotification: true,
///   onTap: () => handleNotifications(),
/// )
///
/// // Dans une Row
/// Row(
///   children: [
///     Expanded(child: LoovaQuickAction(...)),
///     SizedBox(width: context.spacing.md),
///     Expanded(child: LoovaQuickAction(...)),
///   ],
/// )
/// ```
class LoovaQuickAction extends StatelessWidget {
  /// Icône à afficher
  final IconData icon;

  /// Label sous l'icône
  final String label;

  /// Callback au tap
  final VoidCallback onTap;

  /// Si true, affiche un badge rouge de notification
  final bool hasNotification;

  /// Taille de l'icône (défaut: 28)
  final double iconSize;

  const LoovaQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasNotification = false,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // Haptic feedback pour meilleure UX
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.spacing.lg,
          horizontal: context.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(context.radii.md),
          border: Border.all(
            color: hasNotification
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
            width: hasNotification ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Contenu centré
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: hasNotification
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(0.7),
                    size: iconSize,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight:
                      hasNotification ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge de notification
            if (hasNotification)
              Positioned(
                top: -4,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
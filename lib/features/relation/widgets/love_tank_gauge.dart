import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/shared/providers/tanks_provider.dart';
import 'package:lova/shared/ui/semantic_colors.dart';

enum LoveTier { low, mid, high }

class LoveTankGauge extends ConsumerStatefulWidget {
  final int value;
  final VoidCallback onTap;

  const LoveTankGauge({super.key, required this.value, required this.onTap});

  LoveTier get tier {
    if (value <= 24) return LoveTier.low;
    if (value <= 74) return LoveTier.mid;
    return LoveTier.high;
  }

  @override
  ConsumerState<LoveTankGauge> createState() => _LoveTankGaugeState();
}

class _LoveTankGaugeState extends ConsumerState<LoveTankGauge>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _glowController;
  late Animation<double> _fillAnimation;
  late Animation<double> _glowAnimation;

  int _previousValue = 0;
  LoveTier _previousTier = LoveTier.low;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _previousTier = widget.tier;

    _fillController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fillAnimation =
        Tween<double>(
          begin: widget.value / 100,
          end: widget.value / 100,
        ).animate(
          CurvedAnimation(parent: _fillController, curve: Curves.easeOutBack),
        );

    _glowAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(LoveTankGauge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      // Animation de remplissage
      _fillAnimation =
          Tween<double>(
            begin: _previousValue / 100,
            end: widget.value / 100,
          ).animate(
            CurvedAnimation(parent: _fillController, curve: Curves.easeOutBack),
          );

      _fillController.forward(from: 0);

      // Vérifier si on a franchi un palier
      if (_previousTier != widget.tier) {
        _glowController.forward(from: 0);
        HapticFeedback.mediumImpact();
      }

      _previousValue = widget.value;
      _previousTier = widget.tier;
    }
  }

  @override
  void dispose() {
    _fillController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _getTierColor(BuildContext context) {
    switch (widget.tier) {
      case LoveTier.low:
        return SemanticColors.loveLevelLow(context);
      case LoveTier.mid:
        return SemanticColors.loveLevelMid(context);
      case LoveTier.high:
        return SemanticColors.loveLevelHigh(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tierColor = _getTierColor(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: tierColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Effet de glow animé
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 70 + (_glowAnimation.value * 10),
                  height: 70 + (_glowAnimation.value * 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: tierColor.withOpacity(
                        0.3 * (1 - _glowAnimation.value),
                      ),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

            // Jauge circulaire avec remplissage fluide
            AnimatedBuilder(
              animation: _fillAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(60, 60),
                  painter: _LoveTankPainter(
                    fillLevel: _fillAnimation.value,
                    color: tierColor,
                    backgroundColor: SemanticColors.border(context),
                  ),
                );
              },
            ),

            // Icône et valeur
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  color: widget.value > 50
                      ? tierColor
                      : colorScheme.onSurface.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.value}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
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

class _LoveTankPainter extends CustomPainter {
  final double fillLevel;
  final Color color;
  final Color backgroundColor;

  _LoveTankPainter({
    required this.fillLevel,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Fond
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius - 2, backgroundPaint);

    // Remplissage avec effet wave
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * fillLevel;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      -math.pi / 2,
      sweepAngle,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_LoveTankPainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel || oldDelegate.color != color;
  }
}

/// Bottom sheet pour booster la jauge Love Tank
void showLoveTankBoosterSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _LoveTankBoosterSheet(),
  );
}

class _LoveTankBoosterSheet extends ConsumerWidget {
  const _LoveTankBoosterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final actions = [
      const _BoosterAction(
        icon: Icons.calendar_today,
        title: 'Planifier un moment',
        points: '+8',
        action: LoveTankAction.planMoment,
      ),
      const _BoosterAction(
        icon: Icons.favorite_outline,
        title: 'Envoyer une attention',
        points: '+5',
        action: LoveTankAction.sendAttention,
      ),
      const _BoosterAction(
        icon: Icons.lightbulb_outline,
        title: 'Appliquer le conseil',
        points: '+3',
        action: LoveTankAction.applyAdvice,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Booster notre jauge',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          ...actions.map((action) => _buildActionTile(context, ref, action)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    WidgetRef ref,
    _BoosterAction action,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            HapticFeedback.lightImpact();
            await ref
                .read(loveTankProvider.notifier)
                .incrementBy(action.action);

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${action.title} ${action.points}'),
                  backgroundColor: SemanticColors.success(context),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    action.icon,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    action.title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SemanticColors.success(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    action.points,
                    style: textTheme.bodyMedium?.copyWith(
                      color: SemanticColors.success(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoosterAction {
  final IconData icon;
  final String title;
  final String points;
  final LoveTankAction action;

  const _BoosterAction({
    required this.icon,
    required this.title,
    required this.points,
    required this.action,
  });
}

import 'package:flutter/material.dart';

class RitualGaugeWidget extends StatelessWidget {
  final int score;
  final int completedToday;
  final int totalActive;
  final int totalStreak;

  const RitualGaugeWidget({
    Key? key,
    required this.score,
    required this.completedToday,
    required this.totalActive,
    required this.totalStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.1),
            const Color(0xFFFF9068).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Gauge circulaire
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF6B35),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    '$score%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  Text(
                    _getScoreLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                icon: '✅',
                value: '$completedToday/$totalActive',
                label: 'Aujourd\'hui',
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              _buildStatItem(
                context,
                icon: '🔥',
                value: totalStreak.toString(),
                label: 'Total streak',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, {
        required String icon,
        required String value,
        required String label,
      }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  String _getScoreLabel() {
    if (score >= 90) return 'Excellent !';
    if (score >= 70) return 'Très bien';
    if (score >= 50) return 'Bien';
    if (score >= 30) return 'À améliorer';
    return 'Besoin d\'attention';
  }
}
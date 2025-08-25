import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final int value; // Valeur de 0 à 100

  const GaugeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final double percentage = value.clamp(0, 100) / 100;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage < 0.4
                    ? Colors.red
                    : percentage < 0.7
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toString()}%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _labelForValue(value),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _labelForValue(int value) {
    if (value < 40) return 'En crise';
    if (value < 70) return 'Sensible';
    return 'Stable';
  }
}
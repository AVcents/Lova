import 'package:flutter/material.dart';

class EmotionSelector extends StatelessWidget {
  final String selectedEmotion;
  final Function(String) onEmotionSelected;

  const EmotionSelector({
    Key? key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  }) : super(key: key);

  static const List<String> emotions = ['😍', '😊', '😐', '😔', '😡'];
  static const List<String> labels = [
    'Amoureux',
    'Heureux',
    'Neutre',
    'Triste',
    'En colère',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: List.generate(emotions.length, (index) {
        final isSelected = emotions[index] == selectedEmotion;

        return GestureDetector(
          onTap: () => onEmotionSelected(emotions[index]),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    emotions[index],
                    style: TextStyle(fontSize: isSelected ? 36 : 32),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
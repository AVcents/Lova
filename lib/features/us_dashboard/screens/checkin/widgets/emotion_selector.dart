// lib/features/us_dashboard/screens/checkin/widgets/emotion_selector.dart
import 'package:flutter/material.dart';
import 'package:lova/features/us_dashboard/models/emotion_type.dart';

class EmotionSelector extends StatelessWidget {
  final EmotionType selectedEmotion;
  final Function(EmotionType) onEmotionSelected;

  const EmotionSelector({
    Key? key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  }) : super(key: key);

  static final List<EmotionType> emotions = EmotionType.values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: List.generate(emotions.length, (index) {
        final emotion = emotions[index];
        final isSelected = emotion == selectedEmotion;

        return GestureDetector(
          onTap: () => onEmotionSelected(emotion),
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
                    emotion.emoji,
                    style: TextStyle(fontSize: isSelected ? 36 : 32),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emotion.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
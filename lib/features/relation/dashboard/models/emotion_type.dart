// lib/features/relation/dashboard/models/emotion_type.dart

enum EmotionType {
  joyful,
  grateful,
  loved,
  calm,
  neutral,
  tired,
  stressed,
  sad,
  frustrated,
  angry,
}

extension EmotionTypeExtension on EmotionType {
  String get emoji {
    switch (this) {
      case EmotionType.joyful:
        return '😊';
      case EmotionType.grateful:
        return '🙏';
      case EmotionType.loved:
        return '🥰';
      case EmotionType.calm:
        return '😌';
      case EmotionType.neutral:
        return '😐';
      case EmotionType.tired:
        return '😴';
      case EmotionType.stressed:
        return '😰';
      case EmotionType.sad:
        return '😢';
      case EmotionType.frustrated:
        return '😤';
      case EmotionType.angry:
        return '😡';
    }
  }

  String get label {
    switch (this) {
      case EmotionType.joyful:
        return 'Joyeux';
      case EmotionType.grateful:
        return 'Reconnaissant';
      case EmotionType.loved:
        return 'Aimé';
      case EmotionType.calm:
        return 'Calme';
      case EmotionType.neutral:
        return 'Neutre';
      case EmotionType.tired:
        return 'Fatigué';
      case EmotionType.stressed:
        return 'Stressé';
      case EmotionType.sad:
        return 'Triste';
      case EmotionType.frustrated:
        return 'Frustré';
      case EmotionType.angry:
        return 'En colère';
    }
  }

  String toJson() => name;

  static EmotionType fromJson(String value) {
    final lower = value.toLowerCase();
    return EmotionType.values.firstWhere(
      (e) => e.name.toLowerCase() == lower,
      orElse: () => EmotionType.neutral,
    );
  }
}
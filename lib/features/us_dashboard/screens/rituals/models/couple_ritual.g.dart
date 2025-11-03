// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_ritual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoupleRitualImpl _$$CoupleRitualImplFromJson(Map<String, dynamic> json) =>
    _$CoupleRitualImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
      defaultDuration: (json['default_duration'] as num).toInt(),
      durationOptions: (json['duration_options'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      category: json['category'] as String,
      benefits: json['benefits'] as String,
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      tips: json['tips'] as String,
      points: (json['points'] as num).toInt(),
      timesCompleted: (json['timesCompleted'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
    );

Map<String, dynamic> _$$CoupleRitualImplToJson(_$CoupleRitualImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'emoji': instance.emoji,
      'description': instance.description,
      'default_duration': instance.defaultDuration,
      'duration_options': instance.durationOptions,
      'category': instance.category,
      'benefits': instance.benefits,
      'instructions': instance.instructions,
      'tips': instance.tips,
      'points': instance.points,
      'timesCompleted': instance.timesCompleted,
      'currentStreak': instance.currentStreak,
      'isFavorite': instance.isFavorite,
      'isCustom': instance.isCustom,
      'is_premium': instance.isPremium,
    };

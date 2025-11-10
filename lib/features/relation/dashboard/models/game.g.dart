// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  emoji: json['emoji'] as String,
  type: $enumDecode(_$GameTypeEnumMap, json['type']),
  status: $enumDecode(_$GameStatusEnumMap, json['status']),
  cardCount: (json['cardCount'] as num).toInt(),
  duration: json['duration'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  coverImage: json['coverImage'] as String?,
  isFavorite: json['isFavorite'] as bool? ?? false,
  timesPlayed: (json['timesPlayed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'emoji': instance.emoji,
      'type': _$GameTypeEnumMap[instance.type]!,
      'status': _$GameStatusEnumMap[instance.status]!,
      'cardCount': instance.cardCount,
      'duration': instance.duration,
      'tags': instance.tags,
      'coverImage': instance.coverImage,
      'isFavorite': instance.isFavorite,
      'timesPlayed': instance.timesPlayed,
    };

const _$GameTypeEnumMap = {
  GameType.cardGame: 'cardGame',
  GameType.quiz: 'quiz',
  GameType.challenge: 'challenge',
  GameType.roleplay: 'roleplay',
};

const _$GameStatusEnumMap = {
  GameStatus.available: 'available',
  GameStatus.premium: 'premium',
  GameStatus.comingSoon: 'comingSoon',
  GameStatus.locked: 'locked',
};

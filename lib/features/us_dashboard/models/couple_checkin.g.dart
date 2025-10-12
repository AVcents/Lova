// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoupleCheckinImpl _$$CoupleCheckinImplFromJson(Map<String, dynamic> json) =>
    _$CoupleCheckinImpl(
      id: json['id'] as String,
      coupleId: json['coupleId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      connectionScore: (json['connectionScore'] as num).toInt(),
      satisfactionScore: (json['satisfactionScore'] as num).toInt(),
      communicationScore: (json['communicationScore'] as num).toInt(),
      emotionToday: json['emotionToday'] as String,
      whatWentWell: json['whatWentWell'] as String?,
      whatNeedsAttention: json['whatNeedsAttention'] as String?,
      gratitudeNote: json['gratitudeNote'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      partnerCheckinId: json['partnerCheckinId'] as String?,
    );

Map<String, dynamic> _$$CoupleCheckinImplToJson(_$CoupleCheckinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coupleId': instance.coupleId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'connectionScore': instance.connectionScore,
      'satisfactionScore': instance.satisfactionScore,
      'communicationScore': instance.communicationScore,
      'emotionToday': instance.emotionToday,
      'whatWentWell': instance.whatWentWell,
      'whatNeedsAttention': instance.whatNeedsAttention,
      'gratitudeNote': instance.gratitudeNote,
      'isCompleted': instance.isCompleted,
      'partnerCheckinId': instance.partnerCheckinId,
    };

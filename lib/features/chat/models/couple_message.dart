import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_message.freezed.dart';
part 'couple_message.g.dart';

@freezed
class CoupleMessage with _$CoupleMessage {
  const factory CoupleMessage({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'sender_id') required String senderId,
    required String content,
    @JsonKey(name: 'message_type') @Default('normal') String messageType,
    @JsonKey(name: 'is_encrypted') @Default(true) bool isEncrypted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CoupleMessage;

  factory CoupleMessage.fromJson(Map<String, dynamic> json) => _$CoupleMessageFromJson(json);
}

enum MessageType {
  normal,
}

extension MessageTypeX on CoupleMessage {
  MessageType get type {
    return MessageType.normal;
  }
}

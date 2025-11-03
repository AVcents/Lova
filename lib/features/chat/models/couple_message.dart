import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_message.freezed.dart';
part 'couple_message.g.dart';

@freezed
class CoupleMessage with _$CoupleMessage {
  const factory CoupleMessage({
    required String id,
    @JsonKey(name: 'relation_id') required String relationId,
    @JsonKey(name: 'sender_id') String? senderId,  // NULL si AI
    required String content,
    @JsonKey(name: 'message_type') @Default('normal') String messageType,
    @JsonKey(name: 'sos_session_id') String? sosSessionId,
    @JsonKey(name: 'is_encrypted') @Default(true) bool isEncrypted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CoupleMessage;

  factory CoupleMessage.fromJson(Map<String, dynamic> json) => _$CoupleMessageFromJson(json);
}

enum MessageType {
  normal,
  sosUser,
  sosAi,
}

extension MessageTypeX on CoupleMessage {
  MessageType get type {
    switch (messageType) {
      case 'sos_user': return MessageType.sosUser;
      case 'sos_ai': return MessageType.sosAi;
      default: return MessageType.normal;
    }
  }

  bool get isSos => sosSessionId != null;
  bool get isAi => messageType == 'sos_ai';
}

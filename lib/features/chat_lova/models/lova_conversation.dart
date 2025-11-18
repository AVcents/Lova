// lib/features/chat_lova/models/lova_conversation.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

part 'lova_conversation.freezed.dart';
part 'lova_conversation.g.dart';

/// Converter personnalisé pour List<LovaMessage>
class LovaMessageListConverter
    implements JsonConverter<List<LovaMessage>, List<dynamic>> {
  const LovaMessageListConverter();

  @override
  List<LovaMessage> fromJson(List<dynamic> json) {
    return json
        .map((e) => LovaMessage.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<dynamic> toJson(List<LovaMessage> messages) {
    return messages.map((m) => m.toMap()).toList();
  }
}

@freezed
class LovaConversation with _$LovaConversation {
  const factory LovaConversation({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @LovaMessageListConverter() required List<LovaMessage> messages,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _LovaConversation;

  factory LovaConversation.fromJson(Map<String, dynamic> json) =>
      _$LovaConversationFromJson(json);
}

// lib/features/chat_lova/models/lova_message.dart

import 'package:uuid/uuid.dart';

class LovaMessage {
  final String id;  // Ajout de l'ID pour les annotations
  final String content;
  final bool isFromUser;
  final DateTime timestamp;

  LovaMessage({
    String? id,
    required this.content,
    required this.isFromUser,
    DateTime? timestamp,
  }) : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  LovaMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
  }) {
    return LovaMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LovaMessage.fromMap(Map<String, dynamic> map) {
    return LovaMessage(
      id: map['id'] as String,
      content: map['content'] as String,
      isFromUser: map['isFromUser'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
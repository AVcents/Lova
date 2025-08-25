// lib/features/chat_lova/models/lova_message.dart

class LovaMessage {
  final String role; // "user" ou "assistant"
  final String content;
  final DateTime timestamp;
  final bool isPartial; // Indique si le message est en cours de génération

  const LovaMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.isPartial = false, // Par défaut, le message est complet
  });

  bool get isFromUser => role == 'user';

  bool get isUser => isFromUser;

  factory LovaMessage.fromJson(Map<String, dynamic> json) {
    return LovaMessage(
      role: json['role'],
      content: json['content'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isPartial: json['isPartial'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isPartial': isPartial,
    };
  }

  // Méthode utile pour créer une copie avec des modifications
  LovaMessage copyWith({
    String? role,
    String? content,
    DateTime? timestamp,
    bool? isPartial,
  }) {
    return LovaMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isPartial: isPartial ?? this.isPartial,
    );
  }
}
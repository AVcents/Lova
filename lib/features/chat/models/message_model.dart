class MessageModel {
  final int? id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isEncrypted;

  MessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isEncrypted = false,
  });

  // Méthode de conversion vers JSON (utile pour Drift ou API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isEncrypted': isEncrypted,
    };
  }

  // Factory de création depuis JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int?,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEncrypted: json['isEncrypted'] ?? false,
    );
  }
}

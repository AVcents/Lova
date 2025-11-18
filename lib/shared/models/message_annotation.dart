// lib/shared/models/message_annotation.dart

import 'package:uuid/uuid.dart';

/// Types de tags pour annoter les messages
enum AnnotationTag {
  loveQuality('💗', 'Je t\'aime pour ça'),
  dealbreaker('🧱', 'Limite / Dealbreaker'),
  giftIdea('🎁', 'Idée cadeau / envie'),
  favorite('⭐', 'Favori'),
  need('🎯', 'Objectif / Besoin'),
  trigger('⚠️', 'Trigger / à éviter'),
  fact('🧩', 'Fait important');

  final String emoji;
  final String label;

  const AnnotationTag(this.emoji, this.label);

  /// Indique si ce tag apporte des points au Love Tank
  bool get isUseful => switch (this) {
    AnnotationTag.loveQuality ||
    AnnotationTag.favorite ||
    AnnotationTag.need ||
    AnnotationTag.fact ||
    AnnotationTag.giftIdea => true,
    _ => false,
  };

  /// Conversion depuis string pour la sérialisation
  static AnnotationTag fromString(String value) {
    return AnnotationTag.values.firstWhere(
      (tag) => tag.name == value,
      orElse: () => AnnotationTag.favorite,
    );
  }
}

/// Modèle d'annotation pour un message
class MessageAnnotation {
  final String id;
  final String messageId; // UUID du message
  final String coupleId;
  final String authorUserId;
  final AnnotationTag tag;
  final String? note;
  final DateTime createdAt;

  MessageAnnotation({
    String? id,
    required this.messageId,
    required this.coupleId,
    required this.authorUserId,
    required this.tag,
    this.note,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Conversion en Map pour la sérialisation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messageId': messageId,
      'coupleId': coupleId,
      'authorUserId': authorUserId,
      'tag': tag.name,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory depuis Map pour la désérialisation
  factory MessageAnnotation.fromMap(Map<String, dynamic> map) {
    return MessageAnnotation(
      id: map['id'] as String,
      messageId: map['messageId'] as String,
      coupleId: map['coupleId'] as String,
      authorUserId: map['authorUserId'] as String,
      tag: AnnotationTag.fromString(map['tag'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  MessageAnnotation copyWith({
    String? id,
    String? messageId,
    String? coupleId,
    String? authorUserId,
    AnnotationTag? tag,
    String? note,
    DateTime? createdAt,
  }) {
    return MessageAnnotation(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      coupleId: coupleId ?? this.coupleId,
      authorUserId: authorUserId ?? this.authorUserId,
      tag: tag ?? this.tag,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageAnnotation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

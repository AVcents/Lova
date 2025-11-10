enum RelationLinkingStatus { idle, pending, linked, error }

class RelationLinkingState {
  final RelationLinkingStatus status;
  final String? message; // Pour erreurs ou infos
  final String? relationId;
  final String? code;
  final DateTime? expiresAt;

  const RelationLinkingState({
    required this.status,
    this.message,
    this.relationId,
    this.code,
    this.expiresAt,
  });

  // Backward compatibility: status-only factories
  factory RelationLinkingState.idle() =>
      const RelationLinkingState(status: RelationLinkingStatus.idle);

  factory RelationLinkingState.pending() =>
      const RelationLinkingState(status: RelationLinkingStatus.pending);

  // New: linked state can hold extra info
  factory RelationLinkingState.linked({
    String? relationId,
    String? code,
    DateTime? expiresAt,
  }) =>
      RelationLinkingState(
        status: RelationLinkingStatus.linked,
        relationId: relationId,
        code: code,
        expiresAt: expiresAt,
      );

  factory RelationLinkingState.error(String message) => RelationLinkingState(
        status: RelationLinkingStatus.error,
        message: message,
      );
}

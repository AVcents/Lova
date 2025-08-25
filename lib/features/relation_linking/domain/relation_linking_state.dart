enum RelationLinkingStatus {
  idle,
  pending,
  linked,
  error,
}

class RelationLinkingState {
  final RelationLinkingStatus status;
  final String? message; // Pour les erreurs ou infos complémentaires

  const RelationLinkingState({
    required this.status,
    this.message,
  });

  factory RelationLinkingState.idle() =>
      const RelationLinkingState(status: RelationLinkingStatus.idle);

  factory RelationLinkingState.pending() =>
      const RelationLinkingState(status: RelationLinkingStatus.pending);

  factory RelationLinkingState.linked() =>
      const RelationLinkingState(status: RelationLinkingStatus.linked);

  factory RelationLinkingState.error(String message) =>
      RelationLinkingState(status: RelationLinkingStatus.error, message: message);
}
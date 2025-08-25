import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/relation_linking_state.dart';
import '../infrastructure/linking_repository.dart';

final linkRelationControllerProvider = StateNotifierProvider<LinkRelationController, RelationLinkingState>(
      (ref) => LinkRelationController(ref, LinkingRepository()),
);

class LinkRelationController extends StateNotifier<RelationLinkingState> {
  final Ref ref;
  final LinkingRepository repository;

  LinkRelationController(this.ref, this.repository)
      : super(RelationLinkingState.idle());

  /// Génère un code pour l'utilisateur actuel
  String generateCode(String userId) {
    state = RelationLinkingState.pending();
    final code = repository.generateInvitationCode(userId);
    return code;
  }

  /// Tente de lier une relation avec un code
  Future<void> linkWithCode(String code, String userId) async {
    state = RelationLinkingState.pending();

    final success = repository.linkWithCode(code, userId);

    if (success) {
      state = RelationLinkingState.linked();
    } else {
      state = RelationLinkingState.error("Code invalide ou expiré.");
    }
  }

  void reset() {
    state = RelationLinkingState.idle();
  }
}
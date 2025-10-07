import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lova/features/relation_linking/domain/relation_linking_state.dart';
import 'package:lova/features/relation_linking/infrastructure/linking_repository.dart';

final linkRelationControllerProvider =
    StateNotifierProvider.autoDispose<LinkRelationController, RelationLinkingState>(
  (ref) => LinkRelationController(ref, LinkingRepository(Supabase.instance.client)),
);


class LinkRelationController extends StateNotifier<RelationLinkingState> {
  final Ref ref;
  final LinkingRepository repository;

  LinkRelationController(this.ref, this.repository)
    : super(RelationLinkingState.idle());

  /// Génère (ou régénère) un code d'invitation valable 5 minutes
  Future<({String relationId, String code, DateTime expiresAt})> generateCode() async {
    state = RelationLinkingState.pending();
    try {
      final res = await repository.createOrRotate();
      // Laisse l'UI afficher le code + timer via la valeur de retour
      state = RelationLinkingState.idle();
      return res;
    } catch (e) {
      state = RelationLinkingState.error('Impossible de générer le code.');
      rethrow;
    }

  }


  /// Tente de lier une relation avec un code
  Future<void> linkWithCode(String code, String relationMode) async {
    state = RelationLinkingState.pending();
    try {
      await repository.accept(code.trim().toUpperCase(), relationMode);
      state = RelationLinkingState.linked();
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CODE_EXPIRED')) {
        state = RelationLinkingState.error('Code expiré. Regénère un nouveau code.');
      } else if (msg.contains('CODE_INVALID')) {
        state = RelationLinkingState.error('Code invalide. Vérifie et réessaie.');
      } else if (msg.contains('ALREADY_LINKED')) {
        state = RelationLinkingState.error('Ton compte a déjà une relation active.');
      } else if (msg.contains('SELF_LINK_FORBIDDEN')) {
        state = RelationLinkingState.error('Tu ne peux pas te lier avec toi-même.');
      } else {
        state = RelationLinkingState.error('Échec de la liaison.');
      }
    }
  }

  void reset() {
    state = RelationLinkingState.idle();
  }

}


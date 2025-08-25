import 'dart:math';
import 'package:uuid/uuid.dart';

class LinkingRepository {
  final Map<String, String> _pendingRelations = {};

  /// Génère un code UUID unique et stocke l'état "pending"
  String generateInvitationCode(String userId) {
    final code = const Uuid().v4().substring(0, 6).toUpperCase(); // Ex: 'A1B2C3'
    _pendingRelations[code] = userId;
    return code;
  }

  /// Vérifie le code et simule la liaison entre deux utilisateurs
  bool linkWithCode(String code, String otherUserId) {
    final inviterId = _pendingRelations[code];
    if (inviterId == null) {
      return false; // Code invalide
    }

    // Ici on simule la création d’une relation entre inviterId et otherUserId
    _pendingRelations.remove(code); // Code utilisé, on le supprime
    print("Relation créée entre $inviterId et $otherUserId");
    return true;
  }
}
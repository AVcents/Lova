import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_checkin.freezed.dart';
part 'couple_checkin.g.dart';

/// Modèle pour un check-in de couple
@freezed
class CoupleCheckin with _$CoupleCheckin {
  const factory CoupleCheckin({
    required String id,
    required String coupleId,
    required String userId, // Celui qui a fait le check-in
    required DateTime createdAt,

    // Questions/Réponses
    required int connectionScore,        // 1-10 : "Comment te sens-tu connecté(e) à ton partenaire ?"
    required int satisfactionScore,      // 1-10 : "Es-tu satisfait(e) de la relation ?"
    required int communicationScore,     // 1-10 : "La communication est-elle fluide ?"
    required String emotionToday,        // Emoji : 😊, 😐, 😔, 😡, 😍

    String? whatWentWell,               // "Qu'est-ce qui s'est bien passé cette semaine ?"
    String? whatNeedsAttention,         // "Qu'est-ce qui nécessite de l'attention ?"
    String? gratitudeNote,              // "Une chose pour laquelle tu es reconnaissant(e) ?"

    // Métadonnées
    @Default(false) bool isCompleted,  // ✅ CORRIGÉ
    String? partnerCheckinId,           // ID du check-in du partenaire (pour comparaison)
  }) = _CoupleCheckin;

  factory CoupleCheckin.fromJson(Map<String, dynamic> json) =>
      _$CoupleCheckinFromJson(json);
}

/// État pour les statistiques
@freezed
class CoupleCheckinStats with _$CoupleCheckinStats {
  const factory CoupleCheckinStats({
    required double averageConnectionScore,
    required double averageSatisfactionScore,
    required double averageCommunicationScore,
    required List<CoupleCheckin> recentCheckins,
    required int totalCheckins,
    required int currentStreak,
  }) = _CoupleCheckinStats;
}
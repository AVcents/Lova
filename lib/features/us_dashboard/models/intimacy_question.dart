import 'package:freezed_annotation/freezed_annotation.dart';

part 'intimacy_question.freezed.dart';
part 'intimacy_question.g.dart';

/// Type de réponse attendue
enum QuestionFormat {
  openEnded,     // Réponse libre
  yesNo,         // Oui/Non
  scale,         // Échelle 1-10
  choice,        // Choix multiples
  both,          // Les deux répondent
}

/// Catégorie de question
enum QuestionCategory {
  intimacy,      // Intimité physique
  emotional,     // Connexion émotionnelle
  fantasy,       // Fantasmes
  past,          // Passé/Souvenirs
  future,        // Projets/Avenir
  preferences,   // Préférences
}

/// Modèle de question pour le jeu d'intimité
@freezed
class IntimacyQuestion with _$IntimacyQuestion {
  const factory IntimacyQuestion({
    required String id,
    required String question,
    required QuestionFormat format,
    required QuestionCategory category,
    String? subtitle,              // Sous-texte explicatif
    List<String>? choices,         // Pour les choix multiples
    String? tip,                   // Conseil pour répondre
    @Default(false) bool isSpicy,  // Question plus intense
  }) = _IntimacyQuestion;

  factory IntimacyQuestion.fromJson(Map<String, dynamic> json) =>
      _$IntimacyQuestionFromJson(json);
}
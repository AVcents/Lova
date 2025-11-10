import 'package:lova/features/relation/dashboard/models/intimacy_question.dart';

/// Base de données des 53 questions LOOVA Intimité
class IntimacyQuestionsData {
  static final List<IntimacyQuestion> questions = [
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // CATÉGORIE : CONNEXION ÉMOTIONNELLE (10 questions)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    IntimacyQuestion(
      id: '1',
      question: 'Qu\'est-ce qui te fait te sentir le plus aimé(e) dans notre relation ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
      subtitle: 'Partagez ce qui compte vraiment',
    ),

    IntimacyQuestion(
      id: '2',
      question: 'Quel est ton meilleur souvenir intime avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.past,
      subtitle: 'Revivez vos moments magiques',
    ),

    IntimacyQuestion(
      id: '3',
      question: 'Sur une échelle de 1 à 10, à quel point te sens-tu connecté(e) à moi en ce moment ?',
      format: QuestionFormat.scale,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '4',
      question: 'Qu\'est-ce que tu aimerais que je sache sur tes désirs mais que tu n\'oses pas dire ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      subtitle: 'Un espace safe pour partager',
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '5',
      question: 'Qu\'est-ce qui te rend le plus vulnérable avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
      subtitle: 'La vulnérabilité crée la connexion',
    ),

    IntimacyQuestion(
      id: '6',
      question: 'Quel geste de tendresse de ma part te touche le plus ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
      subtitle: 'Apprenez vos langages d\'amour',
    ),

    IntimacyQuestion(
      id: '7',
      question: 'Y a-t-il quelque chose que tu aimerais essayer ensemble pour la première fois ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.future,
    ),

    IntimacyQuestion(
      id: '8',
      question: 'Te sens-tu suffisamment en sécurité pour exprimer tous tes désirs avec moi ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.emotional,
      subtitle: 'Honnêteté et confiance',
    ),

    IntimacyQuestion(
      id: '9',
      question: 'Quel compliment aimerais-tu recevoir plus souvent ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '10',
      question: 'Qu\'est-ce qui t\'attire le plus chez moi : physiquement, émotionnellement ou intellectuellement ?',
      format: QuestionFormat.choice,
      category: QuestionCategory.preferences,
      choices: ['Physiquement', 'Émotionnellement', 'Intellectuellement', 'Tout !'],
    ),

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // CATÉGORIE : INTIMITÉ PHYSIQUE (15 questions)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    IntimacyQuestion(
      id: '11',
      question: 'Quelle est la zone de ton corps que tu aimerais que j\'explore davantage ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '12',
      question: 'Qu\'est-ce qui te met le plus dans l\'ambiance ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
      subtitle: 'Musique, lumière, ambiance...',
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '13',
      question: 'Préfères-tu les moments intimes spontanés ou planifiés ?',
      format: QuestionFormat.choice,
      category: QuestionCategory.preferences,
      choices: ['Spontanés', 'Planifiés', 'Les deux !'],
    ),

    IntimacyQuestion(
      id: '14',
      question: 'Y a-t-il un fantasme que tu aimerais réaliser avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '15',
      question: 'Quel est ton moment préféré de nos instants intimes ?',
      format: QuestionFormat.choice,
      category: QuestionCategory.preferences,
      choices: ['Les préliminaires', 'L\'intensité du moment', 'L\'après, blottis ensemble'],
    ),

    IntimacyQuestion(
      id: '16',
      question: 'Qu\'est-ce que tu aimerais que je fasse différemment pendant nos moments intimes ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      subtitle: 'Feedback bienveillant',
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '17',
      question: 'Sur une échelle de 1 à 10, à quel point es-tu satisfait(e) de notre vie intime ?',
      format: QuestionFormat.scale,
      category: QuestionCategory.intimacy,
    ),

    IntimacyQuestion(
      id: '18',
      question: 'Quel est le compliment qui te fait te sentir le plus désirable ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '19',
      question: 'Aimerais-tu que je prenne plus souvent l\'initiative ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '20',
      question: 'Quel lieu inhabituel aimerais-tu explorer ensemble ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '21',
      question: 'Qu\'est-ce qui te fait te sentir sexy ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '22',
      question: 'Y a-t-il quelque chose de nouveau que tu aimerais essayer ensemble ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.future,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '23',
      question: 'Quel est ton souvenir le plus sensuel de nous ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.past,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '24',
      question: 'Préfères-tu que je sois doux/douce ou plus intense ?',
      format: QuestionFormat.choice,
      category: QuestionCategory.preferences,
      choices: ['Doux/Douce', 'Intense', 'Ça dépend du moment'],
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '25',
      question: 'Qu\'est-ce que tu penses quand je te regarde de cette façon ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
      subtitle: 'Connexion par le regard',
    ),

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // CATÉGORIE : COMMUNICATION & CONFIANCE (12 questions)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    IntimacyQuestion(
      id: '26',
      question: 'Y a-t-il quelque chose dont tu as peur de parler avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '27',
      question: 'Te sens-tu écouté(e) quand tu partages tes désirs ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '28',
      question: 'Qu\'est-ce qui te fait te sentir le plus proche de moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '29',
      question: 'Comment puis-je mieux te montrer que je te désire ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '30',
      question: 'Qu\'est-ce que tu apprécies le plus dans notre communication ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '31',
      question: 'Y a-t-il un tabou que tu aimerais briser avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '32',
      question: 'Te sens-tu libre d\'exprimer tes "non" sans jugement ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.emotional,
      subtitle: 'Le consentement est essentiel',
    ),

    IntimacyQuestion(
      id: '33',
      question: 'Qu\'est-ce qui pourrait améliorer notre intimité émotionnelle ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.future,
    ),

    IntimacyQuestion(
      id: '34',
      question: 'Quel secret intime aimerais-tu me confier ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '35',
      question: 'Comment puis-je te faire sentir plus en sécurité avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '36',
      question: 'Y a-t-il quelque chose que tu aimerais que je sache mais que tu n\'as jamais dit ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    IntimacyQuestion(
      id: '37',
      question: 'Qu\'est-ce qui te rend fier/fière de notre relation ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
    ),

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // CATÉGORIE : EXPLORATION & CRÉATIVITÉ (16 questions)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    IntimacyQuestion(
      id: '38',
      question: 'Si tu pouvais créer le scénario parfait pour une soirée intime, ce serait quoi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '39',
      question: 'Aimerais-tu qu\'on essaye quelque chose de complètement nouveau ensemble ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.future,
    ),

    IntimacyQuestion(
      id: '40',
      question: 'Quel rôle aimerais-tu que je joue pendant un moment intime ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '41',
      question: 'Qu\'est-ce qui te fait perdre le contrôle de la meilleure façon ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '42',
      question: 'Quel est ton fantasme le plus doux ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
    ),

    IntimacyQuestion(
      id: '43',
      question: 'Aimerais-tu qu\'on utilise des accessoires ou des jeux pour pimenter nos moments ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.preferences,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '44',
      question: 'Quelle est la chose la plus audacieuse que tu aimerais faire avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '45',
      question: 'Qu\'est-ce qui te surprendrait agréablement venant de moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '46',
      question: 'Quel endroit romantique aimerais-tu visiter avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.future,
    ),

    IntimacyQuestion(
      id: '47',
      question: 'Si on avait une journée entière rien que pour nous, que ferions-nous ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.fantasy,
    ),

    IntimacyQuestion(
      id: '48',
      question: 'Quel est le geste le plus sexy que je pourrais faire ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '49',
      question: 'Aimerais-tu qu\'on prenne plus de risques ensemble ?',
      format: QuestionFormat.yesNo,
      category: QuestionCategory.future,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '50',
      question: 'Quelle sensation aimerais-tu expérimenter avec moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.intimacy,
      isSpicy: true,
    ),

    IntimacyQuestion(
      id: '51',
      question: 'Qu\'est-ce qui rendrait nos moments encore plus magiques ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.future,
    ),

    IntimacyQuestion(
      id: '52',
      question: 'Quel est le cadeau intime que tu aimerais recevoir de moi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.preferences,
    ),

    IntimacyQuestion(
      id: '53',
      question: 'Si tu devais me décrire en un mot qui évoque notre intimité, ce serait quoi ?',
      format: QuestionFormat.openEnded,
      category: QuestionCategory.emotional,
      subtitle: 'Un mot pour tout résumer',
    ),
  ];

  /// Mélanger les questions aléatoirement
  static List<IntimacyQuestion> getShuffledQuestions() {
    final shuffled = List<IntimacyQuestion>.from(questions);
    shuffled.shuffle();
    return shuffled;
  }

  /// Filtrer par catégorie
  static List<IntimacyQuestion> getByCategory(QuestionCategory category) {
    return questions.where((q) => q.category == category).toList();
  }

  /// Questions non épicées seulement
  static List<IntimacyQuestion> getMildQuestions() {
    return questions.where((q) => !q.isSpicy).toList();
  }

  /// Questions épicées seulement
  static List<IntimacyQuestion> getSpicyQuestions() {
    return questions.where((q) => q.isSpicy).toList();
  }
}
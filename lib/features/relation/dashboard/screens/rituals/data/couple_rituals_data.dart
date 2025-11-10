import 'package:flutter/material.dart';
import 'package:lova/features/relation/dashboard/screens/rituals/models/couple_ritual.dart';

class CoupleRitualsData {
  // Map des couleurs par ID
  static final Map<String, Color> ritualColors = {
    'massages': const Color(0xFFE91E63),
    'calins': const Color(0xFFFF9800),
    'intimite_guidee': const Color(0xFFE91E63),
    'discussion_profonde': const Color(0xFF9C27B0),
    'gratitude_partagee': const Color(0xFFFF9800),
    'mots_amour': const Color(0xFFE91E63),
    'apero_deconnecte': const Color(0xFFFF5722),
    'cuisiner_ensemble': const Color(0xFFFF9800),
    'promenade': const Color(0xFF4CAF50),
    'danse_salon': const Color(0xFFE91E63),
    'meditation_couple': const Color(0xFF9C27B0),
    'etirements_duo': const Color(0xFF4CAF50),
    'lecture_partagee': const Color(0xFF2196F3),
    'questions_connexion': const Color(0xFFFF6B9D),
    'improvisation': const Color(0xFFFF5722),
  };

  static Color getColorForRitual(String ritualId) {
    return ritualColors[ritualId] ?? const Color(0xFF9C27B0);
  }

  static final List<CoupleRitual> predefinedRituals = [
    // INTIMITÉ & CONTACT
    const CoupleRitual(
      id: 'massages',
      title: 'Massages',
      emoji: '💆',
      description: 'Moment de détente et de connexion physique',
      defaultDuration: 20,
      durationOptions: [10, 15, 20, 30],
      category: 'intimité',
      benefits: 'Les massages réduisent le stress, libèrent de l\'oxytocine (hormone de l\'attachement) et renforcent la connexion physique et émotionnelle entre partenaires.',
      instructions: [{'text': 'Créez une ambiance calme avec lumière tamisée. Utilisez de l\'huile de massage. Alternez qui donne et qui reçoit. Communiquez sur la pression et les zones préférées.'}],
      tips: 'Mettez une musique douce, éteignez les téléphones, et prenez votre temps. Concentrez-vous sur le moment présent.',
      points: 20,
    ),

    const CoupleRitual(
      id: 'calins',
      title: 'Câlins intentionnels',
      emoji: '🤗',
      description: 'Moment de connexion et de tendresse',
      defaultDuration: 10,
      durationOptions: [5, 10, 15],
      category: 'intimité',
      benefits: 'Les câlins prolongés (20 secondes minimum) libèrent de l\'ocytocine, réduisent le cortisol (stress) et créent un sentiment de sécurité et d\'appartenance.',
      instructions: [{'text': 'Enlacez-vous confortablement, respirez ensemble, fermez les yeux. Restez présents sans parler. Sentez le corps de l\'autre contre le vôtre.'}],
      tips: 'Un câlin de 6 secondes minimum a des effets mesurables sur le bien-être. Faites-le sans téléphone ni distraction.',
      points: 10,
    ),

    const CoupleRitual(
      id: 'intimite_guidee',
      title: 'Intimité guidée',
      emoji: '💋',
      description: 'Moment d\'intimité et de connexion profonde',
      defaultDuration: 30,
      durationOptions: [20, 30, 45, 60],
      category: 'intimité',
      benefits: 'Renforce l\'intimité physique et émotionnelle, crée de la nouveauté dans la relation, améliore la communication sur les désirs.',
      instructions: [{'text': 'Créez une atmosphère romantique. Prenez le temps des préliminaires. Communiquez vos envies. Soyez présents l\'un à l\'autre.'}],
      tips: 'L\'intimité ne se limite pas au sexe. C\'est un moment de connexion profonde, d\'exploration et de complicité.',
      points: 25,
      isPremium: true,
    ),

    // CONNEXION ÉMOTIONNELLE
    const CoupleRitual(
      id: 'discussion_profonde',
      title: 'Discussion profonde',
      emoji: '💬',
      description: 'Conversation authentique et sans distraction',
      defaultDuration: 20,
      durationOptions: [15, 20, 30],
      category: 'connexion',
      benefits: 'Renforce la connexion émotionnelle, améliore la compréhension mutuelle, crée de l\'intimité émotionnelle et de la complicité.',
      instructions: [{'text': 'Installez-vous confortablement, face à face. Éteignez les téléphones. Posez des questions ouvertes, écoutez vraiment sans juger.'}],
      tips: 'Utilisez les questions du jeu LOOVA Intimité pour guider la conversation. Partagez vos vulnérabilités.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'gratitude_partagee',
      title: 'Gratitude partagée',
      emoji: '🙏',
      description: 'Partager ce pour quoi vous êtes reconnaissants',
      defaultDuration: 10,
      durationOptions: [5, 10],
      category: 'connexion',
      benefits: 'Augmente la satisfaction relationnelle, renforce les émotions positives, crée un focus sur ce qui fonctionne bien dans le couple.',
      instructions: [{'text': 'Tour à tour, partagez 3 choses pour lesquelles vous êtes reconnaissants aujourd\'hui : une pour vous, une pour l\'autre, une pour votre couple.'}],
      tips: 'Soyez spécifique et authentique. Regardez-vous dans les yeux en parlant.',
      points: 10,
    ),

    const CoupleRitual(
      id: 'mots_amour',
      title: 'Mots d\'amour',
      emoji: '❤️',
      description: 'Exprimer verbalement votre amour',
      defaultDuration: 5,
      durationOptions: [5, 10],
      category: 'connexion',
      benefits: 'Renforce le lien émotionnel, comble le besoin d\'affirmation, crée des souvenirs positifs et augmente la satisfaction relationnelle.',
      instructions: [{'text': 'Regardez votre partenaire dans les yeux. Dites-lui ce que vous aimez chez lui/elle, ce qui vous a touché récemment, pourquoi vous l\'aimez.'}],
      tips: 'Soyez précis et sincère. Parlez du cœur, pas de ce qui "devrait" être dit.',
      points: 10,
    ),

    // ACTIVITÉS ENSEMBLE
    const CoupleRitual(
      id: 'apero_deconnecte',
      title: 'Apéro déconnecté',
      emoji: '🍷',
      description: 'Moment convivial sans téléphone',
      defaultDuration: 30,
      durationOptions: [30, 45, 60],
      category: 'activité',
      benefits: 'Crée un espace de déconnexion du quotidien, favorise les échanges spontanés, renforce la complicité dans un contexte détendu.',
      instructions: [{'text': 'Préparez des amuse-gueules et vos boissons préférées. Installez-vous confortablement. Rangez les téléphones. Discutez, rigolez, profitez.'}],
      tips: 'Variez les lieux : terrasse, salon, parc. Testez de nouveaux snacks ou cocktails ensemble.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'cuisiner_ensemble',
      title: 'Cuisiner ensemble',
      emoji: '👨‍🍳',
      description: 'Préparer un repas à deux',
      defaultDuration: 45,
      durationOptions: [30, 45, 60],
      category: 'activité',
      benefits: 'Favorise la collaboration, crée des souvenirs partagés, permet de s\'amuser ensemble dans une activité créative.',
      instructions: [{'text': 'Choisissez une recette ensemble. Répartissez les tâches. Mettez de la musique. Goûtez en cours de route. Amusez-vous !'}],
      tips: 'Essayez une cuisine que vous ne connaissez pas. Dansez entre deux étapes. Prenez un verre en cuisinant.',
      points: 20,
    ),

    const CoupleRitual(
      id: 'promenade',
      title: 'Promenade main dans la main',
      emoji: '🚶',
      description: 'Marche tranquille ensemble',
      defaultDuration: 30,
      durationOptions: [20, 30, 45],
      category: 'activité',
      benefits: 'Favorise les conversations naturelles, réduit le stress, booste l\'humeur, renforce la connexion physique par le toucher.',
      instructions: [{'text': 'Sortez dehors, dans un parc ou votre quartier. Marchez à un rythme confortable, main dans la main. Discutez ou profitez du silence ensemble.'}],
      tips: 'Variez les parcours. Observez votre environnement ensemble. Arrêtez-vous pour vous embrasser.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'danse_salon',
      title: 'Danse dans le salon',
      emoji: '💃',
      description: 'Moment de fun et de complicité',
      defaultDuration: 15,
      durationOptions: [10, 15, 20],
      category: 'fun',
      benefits: 'Libère des endorphines, crée du rire et de la légèreté, renforce la connexion physique, brise la routine.',
      instructions: [{'text': 'Mettez votre playlist préférée. Dansez collés ou séparés. Peu importe le style, amusez-vous ! Rigolez ensemble.'}],
      tips: 'Alternez musiques douces et rythmées. N\'ayez pas peur du ridicule, c\'est ça qui est drôle !',
      points: 15,
    ),

    // BIEN-ÊTRE À DEUX
    const CoupleRitual(
      id: 'meditation_couple',
      title: 'Méditation guidée couple',
      emoji: '🧘',
      description: 'Moment de pleine conscience à deux',
      defaultDuration: 15,
      durationOptions: [10, 15, 20],
      category: 'bien-être',
      benefits: 'Synchronise les énergies, réduit le stress partagé, crée un espace de calme commun, améliore la présence mutuelle.',
      instructions: [{'text': 'Asseyez-vous confortablement côte à côte ou face à face. Fermez les yeux. Respirez ensemble. Suivez une méditation guidée ou restez en silence.'}],
      tips: 'Essayez la méditation de la loving-kindness (bienveillance) en pensant l\'un à l\'autre.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'etirements_duo',
      title: 'Étirements en duo',
      emoji: '🤸',
      description: 'Étirements doux à deux',
      defaultDuration: 15,
      durationOptions: [10, 15, 20],
      category: 'bien-être',
      benefits: 'Améliore la flexibilité, réduit les tensions, crée un moment de soin mutuel, favorise le toucher bienveillant.',
      instructions: [{'text': 'Trouvez un espace dégagé. Faites des étirements doux ensemble, en vous aidant mutuellement. Respirez profondément.'}],
      tips: 'Cherchez des routines d\'étirements couple sur YouTube. Allez-y doucement, sans forcer.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'lecture_partagee',
      title: 'Lecture partagée',
      emoji: '📖',
      description: 'Lire ensemble ou se faire la lecture',
      defaultDuration: 20,
      durationOptions: [15, 20, 30],
      category: 'bien-être',
      benefits: 'Crée un rituel apaisant, favorise l\'imaginaire commun, moment de détente intellectuelle partagée.',
      instructions: [{'text': 'Installez-vous confortablement. Lisez le même livre chacun de votre côté ou lisez à voix haute l\'un pour l\'autre.'}],
      tips: 'Choisissez un livre que vous aimez tous les deux. Échangez sur vos passages préférés.',
      points: 10,
    ),

    // JEUX & FUN
    const CoupleRitual(
      id: 'questions_connexion',
      title: 'Jeu de questions',
      emoji: '🎲',
      description: 'Questions pour approfondir votre connexion',
      defaultDuration: 20,
      durationOptions: [15, 20, 30],
      category: 'fun',
      benefits: 'Découvrez de nouvelles facettes l\'un de l\'autre, créez des conversations profondes dans un format ludique.',
      instructions: [{'text': 'Utilisez le jeu LOOVA Intimité ou créez vos propres questions. Répondez tour à tour avec honnêteté et bienveillance.'}],
      tips: 'Pas de jugement, juste de la curiosité. C\'est un moment de découverte mutuelle.',
      points: 15,
    ),

    const CoupleRitual(
      id: 'improvisation',
      title: 'Improvisation / Sketch',
      emoji: '🎭',
      description: 'Jeux d\'impro et moments drôles',
      defaultDuration: 20,
      durationOptions: [15, 20, 30],
      category: 'fun',
      benefits: 'Libère la créativité, crée du rire, brise les inhibitions, renforce la complicité par le jeu.',
      instructions: [{'text': 'Inventez des scénarios absurdes, faites des imitations, créez des personnages. L\'objectif : rire ensemble !'}],
      tips: 'N\'ayez pas peur du ridicule, c\'est le but ! Plus c\'est absurde, mieux c\'est.',
      points: 15,
      isPremium: true,
    ),
  ];

  static List<CoupleRitual> getFreeRituals() =>
      predefinedRituals.where((r) => !r.isPremium).toList();

  static List<CoupleRitual> getAllRituals() => predefinedRituals;

  static List<CoupleRitual> getRitualsByCategory(String category) =>
      predefinedRituals.where((r) => r.category == category).toList();

  static CoupleRitual? getRitualById(String id) {
    try {
      return predefinedRituals.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
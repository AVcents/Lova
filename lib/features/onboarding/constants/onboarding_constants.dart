// lib/features/onboarding/constants/onboarding_constants.dart

import 'package:flutter/material.dart';

class OnboardingConstants {
  // Durées d'animation
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 400);

  // Délais
  static const Duration redirectDelay = Duration(seconds: 3);
  static const Duration resendEmailDelay = Duration(seconds: 60);

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int inviteCodeLength = 6;

  // Objectifs disponibles
  static const List<OnboardingGoal> availableGoals = [
    OnboardingGoal(
      id: 'communication',
      label: 'Améliorer la communication',
      emoji: '💬',
      description: 'Apprendre à mieux exprimer vos besoins et écouter l\'autre',
    ),
    OnboardingGoal(
      id: 'passion',
      label: 'Raviver la passion',
      emoji: '🔥',
      description: 'Retrouver l\'étincelle et l\'excitation des débuts',
    ),
    OnboardingGoal(
      id: 'trust',
      label: 'Renforcer la confiance',
      emoji: '🤝',
      description: 'Construire une relation basée sur la confiance mutuelle',
    ),
    OnboardingGoal(
      id: 'intimacy',
      label: 'Développer l\'intimité',
      emoji: '💕',
      description: 'Créer une connexion plus profonde et authentique',
    ),
    OnboardingGoal(
      id: 'conflict',
      label: 'Gérer les conflits',
      emoji: '⚖️',
      description: 'Apprendre à résoudre les désaccords de manière saine',
    ),
    OnboardingGoal(
      id: 'growth',
      label: 'Grandir ensemble',
      emoji: '🌱',
      description: 'Évoluer ensemble tout en respectant l\'individualité',
    ),
    OnboardingGoal(
      id: 'fun',
      label: 'Plus de moments fun',
      emoji: '🎉',
      description: 'Retrouver la légèreté et le plaisir d\'être ensemble',
    ),
    OnboardingGoal(
      id: 'understanding',
      label: 'Mieux se comprendre',
      emoji: '🧠',
      description: 'Développer l\'empathie et la compréhension mutuelle',
    ),
    OnboardingGoal(
      id: 'support',
      label: 'Se soutenir mutuellement',
      emoji: '🤗',
      description: 'Être le meilleur allié de l\'autre dans la vie',
    ),
    OnboardingGoal(
      id: 'romance',
      label: 'Plus de romantisme',
      emoji: '🌹',
      description: 'Cultiver les gestes tendres et les attentions',
    ),
  ];

  // Intérêts disponibles
  static const List<OnboardingInterest> availableInterests = [
    OnboardingInterest(
      id: 'travel',
      label: 'Voyages',
      emoji: '✈️',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'food',
      label: 'Gastronomie',
      emoji: '🍜',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'sports',
      label: 'Sport',
      emoji: '⚽',
      category: InterestCategory.activities,
    ),
    OnboardingInterest(
      id: 'music',
      label: 'Musique',
      emoji: '🎵',
      category: InterestCategory.culture,
    ),
    OnboardingInterest(
      id: 'movies',
      label: 'Cinéma',
      emoji: '🎬',
      category: InterestCategory.culture,
    ),
    OnboardingInterest(
      id: 'reading',
      label: 'Lecture',
      emoji: '📚',
      category: InterestCategory.culture,
    ),
    OnboardingInterest(
      id: 'gaming',
      label: 'Jeux vidéo',
      emoji: '🎮',
      category: InterestCategory.activities,
    ),
    OnboardingInterest(
      id: 'nature',
      label: 'Nature',
      emoji: '🌿',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'art',
      label: 'Art',
      emoji: '🎨',
      category: InterestCategory.culture,
    ),
    OnboardingInterest(
      id: 'tech',
      label: 'Technologie',
      emoji: '💻',
      category: InterestCategory.professional,
    ),
    OnboardingInterest(
      id: 'wellness',
      label: 'Bien-être',
      emoji: '🧘',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'dancing',
      label: 'Danse',
      emoji: '💃',
      category: InterestCategory.activities,
    ),
    OnboardingInterest(
      id: 'photography',
      label: 'Photographie',
      emoji: '📷',
      category: InterestCategory.culture,
    ),
    OnboardingInterest(
      id: 'cooking',
      label: 'Cuisine',
      emoji: '👨‍🍳',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'pets',
      label: 'Animaux',
      emoji: '🐾',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'meditation',
      label: 'Méditation',
      emoji: '🧘‍♀️',
      category: InterestCategory.lifestyle,
    ),
    OnboardingInterest(
      id: 'entrepreneurship',
      label: 'Entrepreneuriat',
      emoji: '🚀',
      category: InterestCategory.professional,
    ),
    OnboardingInterest(
      id: 'volunteering',
      label: 'Bénévolat',
      emoji: '🤲',
      category: InterestCategory.activities,
    ),
  ];

  // Messages d'erreur
  static const Map<String, String> errorMessages = {
    'name_required': 'Le prénom est obligatoire',
    'name_too_short': 'Le prénom doit contenir au moins $minNameLength caractères',
    'name_too_long': 'Le prénom ne peut pas dépasser $maxNameLength caractères',
    'invalid_code': 'Code invalide ou expiré',
    'network_error': 'Problème de connexion. Veuillez réessayer.',
    'unknown_error': 'Une erreur est survenue. Veuillez réessayer.',
    'goals_required': 'Veuillez sélectionner au moins un objectif',
  };

  // Couleurs thématiques
  static const Map<String, Color> statusColors = {
    'solo': Color(0xFFFF6B6B),
    'couple': Color(0xFFFF1744),
  };

  // Gradients
  static const List<List<Color>> onboardingGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)], // Welcome
    [Color(0xFF667EEA), Color(0xFF764BA2)], // Status
    [Color(0xFF48C9B0), Color(0xFF6C5CE7)], // Goals
    [Color(0xFFFD79A8), Color(0xFFFDCB6E)], // Profile
    [Color(0xFFA29BFE), Color(0xFFFD79A8)], // Invite
  ];
}

// Classe pour représenter un objectif
class OnboardingGoal {
  final String id;
  final String label;
  final String emoji;
  final String description;

  const OnboardingGoal({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
  });
}

// Classe pour représenter un intérêt
class OnboardingInterest {
  final String id;
  final String label;
  final String emoji;
  final InterestCategory category;

  const OnboardingInterest({
    required this.id,
    required this.label,
    required this.emoji,
    required this.category,
  });
}

// Enum pour les catégories d'intérêts
enum InterestCategory {
  lifestyle('Style de vie'),
  culture('Culture'),
  activities('Activités'),
  professional('Professionnel');

  final String label;
  const InterestCategory(this.label);
}
# Architecture LOVA

## Vue d'ensemble

LOVA est une application Flutter suivant une architecture **feature-first** avec séparation en 4 couches.

## Structure du projet

```
lib/
├── main.dart              # Point d'entrée
├── app.dart               # Configuration app
├── bootstrap.dart         # Init services
├── core/                  # Infrastructure partagée
├── features/              # Features métier (bounded contexts)
├── router/                # Navigation GoRouter
├── shared/                # Code vraiment partagé (design system, utils)
└── theme/                 # Thème global
```

## Features principales

- **auth** : Authentification (sign in/up, forgot password)
- **onboarding** : Parcours d'onboarding
- **me** : Dashboard solo (checkin, journal, rituals, intentions)
- **us** : Dashboard couple (checkin couple, jeux, rituels couple)
- **chat** : Chat couple + chat avec Lova (IA)
- **sos** : Médiation de crise avec IA
- **relation_linking** : Lier un couple
- **settings** : Paramètres utilisateur
- **notifications** : Gestion des notifications

## Stack technique

- **UI Framework** : Flutter 3.32.0
- **State Management** : Riverpod (StateNotifier pattern)
- **Navigation** : GoRouter
- **Backend** : Supabase (auth, DB, storage, edge functions)
- **Local DB** : Drift (cache + données chiffrées)
- **Notifications** : Firebase Cloud Messaging
- **API externe** : OpenAI (chat Lova)

## Pattern architecture par feature

Chaque feature suit une architecture en 4 couches :

```
features/<feature_name>/
  presentation/      # UI (pages, widgets)
  application/       # State management (controllers, providers)
  domain/           # Business logic (entities, usecases, repositories interfaces)
  infrastructure/   # Implementations (Supabase, Drift, APIs)
```

## Principes

1. **Single source of truth** : Riverpod StateNotifier par concept métier
2. **Separation of concerns** : 4 couches avec responsabilités claires
3. **Dependency inversion** : domain/ ne dépend de rien, infrastructure/ implémente les interfaces
4. **Feature-first** : Chaque feature est un bounded context autonome

---

*Document en cours de rédaction. Sera complété au fur et à mesure du refactor.*

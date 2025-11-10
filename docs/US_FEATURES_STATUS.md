# État des Fonctionnalités US - LOVA

## ✅ PHASE 1 COMPLÉTÉE : Méthodes GamesController

### Problème 1 : Méthode toggleFavorite manquante ✅ RÉSOLU

**Corrections apportées :**

1. ✅ **GamesController** (`lib/features/us/application/games/games_controller.dart`)
   - Ajout de `toggleFavorite(String gameId, {bool? isFavorite})`
   - Ajout de `incrementPlayCount(String gameId)`
   - Ajout de `loadSession(String sessionId)`
   - Mise à jour locale du state avant appel au repository (réactivité UI)

2. ✅ **GamesRepository** (`lib/features/us/domain/repositories/games_repository.dart`)
   - Ajout de l'interface `toggleFavorite(String gameId, bool isFavorite)`
   - Ajout de l'interface `incrementPlayCount(String gameId)`

3. ✅ **SupabaseGamesRepository** (`lib/features/us/infrastructure/supabase_games_repository.dart`)
   - Implémentation de `toggleFavorite()` avec upsert sur `user_game_preferences`
   - Implémentation de `incrementPlayCount()` avec appel RPC
   - Gestion gracieuse des erreurs (tables/fonctions non existantes)

---

## 📋 ROUTES US IDENTIFIÉES

### Routes Check-in Couple

| Route | Nom | Page | Statut |
|-------|-----|------|--------|
| `/couple-checkin` | coupleCheckin | CoupleCheckinPage | ⚠️ À vérifier |
| `/couple-checkin-results` | coupleCheckinResults | CoupleCheckinResultsPage | ⚠️ À vérifier |
| `/couple-checkin-history` | coupleCheckinHistory | CoupleCheckinHistoryPage | ⚠️ À vérifier |

**Fonctionnalités à tester :**
- [ ] Formulaire de check-in se charge
- [ ] Sélection des scores (connection, satisfaction, communication)
- [ ] Sélection de l'émotion
- [ ] Saisie du texte (gratitude, préoccupation, besoin)
- [ ] Soumission du formulaire
- [ ] Redirection vers results
- [ ] Affichage de l'historique

---

### Routes Jeux de Connexion

| Route | Nom | Page | Statut |
|-------|-----|------|--------|
| `/connection-games` | - | GamesLibraryPage | ⚠️ À vérifier |
| `/deck-selection` | deckSelection | DeckSelectionPage | ⚠️ À vérifier |
| `/intimacy-card-game/:sessionId` | intimacyCardGame | IntimacyCardGamePage | ⚠️ À vérifier |

**Fonctionnalités à tester :**
- [x] Liste des jeux s'affiche (GamesLibraryPage)
- [x] Bouton Favorite fonctionne (toggleFavorite implémentée)
- [x] Compteur de parties fonctionne (incrementPlayCount implémentée)
- [ ] Clic sur un jeu → Redirection vers deck-selection
- [ ] Liste des decks s'affiche
- [ ] Indicateur owned/free/payant
- [ ] Progression du deck
- [ ] Bouton "Jouer" → Création de session
- [ ] Session se charge dans IntimacyCardGamePage
- [ ] Navigation entre cartes
- [ ] Réponses aux cartes
- [ ] Lecture des réponses du partenaire
- [ ] Fin de session

**Problèmes connus :**
- ⚠️ `CreateSessionParams` remplacé par `Map<String, dynamic>` dans deck_selection_page.dart
- ⚠️ `relationId` et `inviteeId` hardcodés en "temp-" (ligne 297-300)
  - **À FAIRE** : Récupérer depuis un provider d'auth/relation

---

### Routes Rituels Couple

| Route | Nom | Page | Statut |
|-------|-----|------|--------|
| `/couple-rituals` | coupleRituals | CoupleRitualsLibraryPage | ⚠️ À vérifier |
| `/couple-ritual-history` | coupleRitualHistory | CoupleRitualHistoryPage | ⚠️ À vérifier |
| `/create-couple-ritual` | - | CreateCoupleRitualPage | ⚠️ À vérifier |

**Fonctionnalités à tester :**
- [ ] Liste des rituels s'affiche
- [ ] Marquage favoris fonctionne
- [ ] Démarrage d'un rituel
- [ ] Exécution du rituel
- [ ] Historique s'affiche

---

### Routes Autres US

| Route | Nom | Page | Statut |
|-------|-----|------|--------|
| `/chat-couple` | - | ChatCouplePage | ⚠️ À vérifier |
| `/library-us` | - | LibraryUsPage | ⚠️ À vérifier |

---

## 🔧 TÂCHES RESTANTES

### Priorité HAUTE

1. **Fixer les TODOs dans deck_selection_page.dart (ligne 295-301)**
   ```dart
   // TODO: Get relationId and inviteeId from appropriate providers
   final params = {
     'relationId': 'temp-relation-id', // ← HARDCODÉ
     'gameId': gameId,
     'deckId': deck.id,
     'inviteeId': 'temp-invitee-id', // ← HARDCODÉ
     'sessionType': type,
   };
   ```
   **Solution :**
   - Créer un `relationProvider` qui récupère la relation active de l'utilisateur
   - Récupérer `partnerId` depuis la relation
   - Remplacer les valeurs hardcodées

2. **Tester chaque route US manuellement**
   - Lancer l'app sur simulateur
   - Naviguer vers chaque page
   - Noter les erreurs dans la console
   - Documenter les fonctionnalités cassées

3. **Vérifier les providers manquants**
   - `activeSessionForGameProvider` utilisé mais peut retourner null
   - `deckProgressProvider` implémenté mais retourne toujours null (TODO ligne 82)
   - `unlockDeckProvider` implémenté mais vide (TODO ligne 92)

### Priorité MOYENNE

4. **Créer les tables Supabase manquantes (si nécessaire)**
   - `user_game_preferences` (pour toggleFavorite)
   - Fonction RPC `increment_game_play_count`

5. **Tester le flux complet d'un jeu**
   - Connexion → Jeux → Deck → Session → Cartes → Fin
   - Vérifier les notifications push
   - Vérifier les mises à jour temps réel (watchSession)

### Priorité BASSE

6. **Améliorer la gestion d'erreurs**
   - Ajouter des messages d'erreur user-friendly
   - Gérer les cas offline
   - Retry logic

---

## 📝 NOTES TECHNIQUES

### Architecture Games/US

```
domain/
  entities/
    - game.dart (Game, GameStatus)
    - game_card_deck.dart (GameCardDeck, DeckProgress, DifficultyLevel)
    - game_session.dart (GameSession, SessionStatus, SessionType)
    - game_card.dart (GameCard)
    - game_card_answer.dart (GameCardAnswer)
  repositories/
    - games_repository.dart (interface)

application/
  games/
    - games_controller.dart (StateNotifier)
    - games_state.dart
    - games_providers.dart (Provider registry)

infrastructure/
  - supabase_games_repository.dart (implémentation)

presentation/
  pages/
    - games_library_page.dart
    - deck_selection_page.dart
    - intimacy_card_game_page.dart
    - couple_checkin_page.dart
    - etc.
```

### Providers Clés

- `gamesControllerProvider` : Controller principal
- `gamesLibraryProvider` : Liste des jeux
- `availableDecksProvider` : Decks disponibles
- `ownedDecksProvider` : Decks possédés
- `currentGameSessionProvider` : Session en cours
- `activeSessionForGameProvider(gameId)` : Session active pour un jeu
- `createSessionProvider(params)` : Crée une session
- `deckProgressProvider(deckId)` : Progression d'un deck
- `unlockDeckProvider(deckId)` : Débloque un deck

---

## 🚀 PROCHAINES ÉTAPES

1. **Lancer l'app et tester** chaque route US
2. **Documenter les erreurs** rencontrées
3. **Corriger les bugs** identifiés
4. **Compléter les TODOs** critiques
5. **Créer les tables/fonctions** Supabase manquantes
6. **Tester le flux complet** E2E

---

**Dernière mise à jour** : 2025-11-05
**Status global** : ⚠️ En cours de vérification

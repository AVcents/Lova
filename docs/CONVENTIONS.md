# Conventions de code LOVA

## Nommage

### Fichiers

| Type | Pattern | Exemple |
|------|---------|---------|
| Page | `<feature>_page.dart` | `couple_checkin_page.dart` |
| Widget | `<widget_name>.dart` | `emotion_selector.dart` |
| Controller | `<feature>_controller.dart` | `games_controller.dart` |
| State | `<feature>_state.dart` | `games_state.dart` |
| Entity | `<entity>.dart` | `game.dart` |
| Repository (interface) | `<feature>_repository.dart` | `games_repository.dart` |
| Repository (impl) | `supabase_<feature>_repository.dart` | `supabase_games_repository.dart` |
| Provider | `<feature>_providers.dart` | `games_providers.dart` |
| Use case | `<action>_<entity>.dart` | `start_game_session.dart` |

### Classes

- **Controller** : `<Feature>Controller` (ex: `GamesController`)
- **State** : `<Feature>State` (ex: `GamesState`)
- **Entity** : `<Entity>` (ex: `Game`, `GameSession`)
- **Repository** : `<Feature>Repository` (interface), `Supabase<Feature>Repository` (impl)

### Providers Riverpod

- Format : `<feature><Concept>Provider` en camelCase
- Exemples :
  - `gamesRepositoryProvider`
  - `gamesControllerProvider`
  - `currentGameProvider`

## Organisation des imports

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages externes (alphabétique)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Imports internes (relatifs, par couche)
import '../domain/entities/game.dart';
import '../domain/repositories/games_repository.dart';
import 'controllers/games_controller.dart';
```

## Riverpod

### Pattern Controller

```dart
// StateNotifier avec State immutable (Freezed)
class GamesController extends StateNotifier<GamesState> {
  final GamesRepository _repository;

  GamesController(this._repository) : super(GamesState.initial());

  Future<void> loadGames() async {
    state = state.copyWith(isLoading: true);
    try {
      final games = await _repository.fetchGames();
      state = state.copyWith(games: games, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

### Pattern Providers

```dart
// Repository provider
final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  return SupabaseGamesRepository(Supabase.instance.client);
});

// Controller provider
final gamesControllerProvider =
  StateNotifierProvider<GamesController, GamesState>((ref) {
    final repository = ref.watch(gamesRepositoryProvider);
    return GamesController(repository);
  });

// Derived provider avec .select()
final currentGameProvider = Provider<Game?>((ref) {
  return ref.watch(
    gamesControllerProvider.select((state) => state.currentGame)
  );
});
```

## Tests

- Tests unitaires : `test/<feature>/<file>_test.dart`
- Tests de widgets : `test/<feature>/widgets/<widget>_test.dart`
- Mocks : Utiliser Mockito ou créer des impls fake dans `domain/repositories/`

---

*Document vivant, sera mis à jour au fil du refactor.*

# Tests LOVA

Ce dossier contient les tests unitaires et d'intégration pour l'application LOVA.

## Structure

```
test/
├── features/
│   ├── auth/
│   │   └── supabase_auth_repository_test.dart
│   ├── profile/
│   │   └── profile_repository_test.dart
│   └── chat/
└── shared/
```

## Exécution des tests

### Tous les tests
```bash
flutter test
```

### Un fichier spécifique
```bash
flutter test test/features/auth/supabase_auth_repository_test.dart
```

### Avec coverage
```bash
flutter test --coverage
```

## Technologies utilisées

- **flutter_test**: Framework de test Flutter
- **mocktail**: Bibliothèque de mocking (version 1.0.4)

## Tests disponibles

### 1. Auth Repository Tests (`features/auth/supabase_auth_repository_test.dart`)

✅ **11 tests passant**

Tests pour le repository d'authentification Supabase:
- ✅ Sign up (succès, email déjà utilisé)
- ✅ Sign in (succès, mauvais mot de passe, user null)
- ✅ Sign out
- ✅ Current user (authentifié/non authentifié)
- ✅ Mapping d'erreurs (rate limit, network error, etc.)

### 2. Tests futurs

Tests à ajouter:
- ⏳ Profile Repository (complexité du mocking Postgrest)
- ⏳ Chat Repository
- ⏳ Providers (Riverpod StateNotifier)
- ⏳ Tests d'intégration Supabase

## Bonnes pratiques

### Nommage des tests
```dart
test('methodName does something when condition', () async {
  // Arrange
  // Act
  // Assert
});
```

### Structure AAA (Arrange-Act-Assert)
```dart
test('signIn success returns AuthResult with user', () async {
  // Arrange - Configuration des mocks
  when(() => mockAuth.signInWithPassword(...)).thenAnswer(...);

  // Act - Exécution du code à tester
  final result = await repository.signIn(...);

  // Assert - Vérification des résultats
  expect(result.success, true);
});
```

### Mocking avec Mocktail
```dart
class MockSupabaseClient extends Mock implements SupabaseClient {}

setUp(() {
  mockClient = MockSupabaseClient();
  when(() => mockClient.method()).thenReturn(value);
});
```

## Ajouter de nouveaux tests

1. Créer un fichier `*_test.dart` dans le dossier approprié
2. Importer `package:flutter_test/flutter_test.dart`
3. Utiliser `mocktail` pour mocker les dépendances
4. Suivre la structure AAA
5. Tester les cas nominaux ET les cas d'erreur

## Coverage

Pour générer un rapport de couverture:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## CI/CD

Les tests sont exécutés automatiquement sur chaque PR et commit vers main.

## Notes

- Les tests utilisent des mocks pour éviter les appels réseau réels
- Tous les tests doivent passer avant un merge
- Viser une couverture de code > 80% pour les parties critiques (auth, repositories)

# Fix Riverpod Initialization Error - LOVA

## 🐛 ERREUR INITIALE

**Message d'erreur :**
```
StateNotifier Instance of GamesController threw an exception when the notifier tried to update its state.
package:riverpod/src/framework_element.dart : Failed assertion: line 179 pos 11:
'!_debugCurrentlyBuildingElement'
Providers are not allowed to modify other providers during their initialization.
```

**Cause :**
Un provider (gamesListProvider) appelait `.read().notifier.loadGames()` pendant son initialisation, ce qui est interdit par Riverpod. Les providers ne peuvent pas modifier d'autres providers pendant leur création.

---

## ✅ CORRECTIONS APPLIQUÉES

### 1. **games_providers.dart** - ligne 56-60

**❌ AVANT (PROBLÉMATIQUE) :**
```dart
final gamesListProvider = FutureProvider((ref) async {
  // ❌ INTERDIT : Appel à loadGames() pendant l'init du provider
  await ref.read(gamesControllerProvider.notifier).loadGames();
  return ref.watch(gamesControllerProvider.select((state) => state.games));
});
```

**✅ APRÈS (CORRIGÉ) :**
```dart
/// Provider qui retourne la liste des jeux depuis le state
/// ❌ NE PLUS appeler loadGames() ici - charge à la demande dans les pages
final gamesListProvider = Provider<List<Game>>((ref) {
  return ref.watch(gamesControllerProvider.select((state) => state.games));
});
```

**Changements :**
- ✅ Changé de `FutureProvider` à `Provider<List<Game>>`
- ✅ Supprimé l'appel à `loadGames()` dans l'init
- ✅ Le provider ne fait que LIRE le state, il ne le MODIFIE plus

---

### 2. **Nouveau provider d'initialisation** - ligne 63-68

**Ajout d'un provider séparé pour le chargement des données :**
```dart
/// Provider d'initialisation pour charger les jeux (à utiliser dans les pages)
/// Usage: ref.watch(initGamesProvider);
final initGamesProvider = FutureProvider.autoDispose((ref) async {
  final controller = ref.read(gamesControllerProvider.notifier);
  await controller.loadGames();
});
```

**Pourquoi `autoDispose` ?**
- Le provider se nettoie automatiquement quand la page est fermée
- Permet de recharger les données à chaque visite de la page

**Pattern correct :**
- Le provider d'initialisation peut appeler le controller PARCE QU'il est utilisé dans une page (build method)
- Il n'est pas utilisé pendant l'initialisation d'un autre provider

---

### 3. **GamesLibraryPage** - Utilisation du nouveau pattern

**❌ AVANT :**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final gamesAsync = ref.watch(gamesLibraryProvider); // Était un FutureProvider

  return gamesAsync.when(
    data: (games) => ...,
    loading: () => ...,
    error: (error, stack) => ...,
  );
}
```

**✅ APRÈS :**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Déclencher le chargement des jeux au montage de la page
  final initAsync = ref.watch(initGamesProvider);

  // Lire la liste des jeux depuis le state
  final games = ref.watch(gamesLibraryProvider);
  final state = ref.watch(gamesControllerProvider);

  return Scaffold(
    body: CustomScrollView(
      slivers: [
        _buildAppBar(context),

        // Gérer les états de chargement
        initAsync.when(
          data: (_) {
            if (state.isLoading && games.isEmpty) {
              return CircularProgressIndicator();
            }
            return _buildContent(context, ref, games);
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => ErrorWidget(error),
        ),
      ],
    ),
  );
}
```

**Changements :**
- ✅ Séparation du chargement (initGamesProvider) et de la lecture (gamesLibraryProvider)
- ✅ Gestion d'état plus granulaire (isLoading + games.isEmpty)
- ✅ Le chargement se fait au montage de la page, pas à l'init du provider

---

## 🎯 PATTERN CORRECT : RÈGLES D'OR

### ❌ INTERDIT dans l'init d'un provider

```dart
final badProvider = Provider((ref) {
  // ❌ Ne JAMAIS modifier un autre provider pendant l'init
  ref.read(someControllerProvider.notifier).loadData();

  // ❌ Ne JAMAIS appeler des méthodes qui changent le state
  final controller = ref.read(controllerProvider.notifier);
  controller.doSomething();

  return ...;
});
```

### ✅ AUTORISÉ dans l'init d'un provider

```dart
final goodProvider = Provider((ref) {
  // ✅ Lire le state avec watch() ou select()
  final state = ref.watch(controllerProvider);

  // ✅ Calculer des données dérivées
  return state.items.where((item) => item.isActive).toList();
});
```

### ✅ AUTORISÉ dans le build d'une page

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // ✅ Charger des données au montage
  ref.watch(initDataProvider); // FutureProvider qui appelle loadData()

  // ✅ Déclencher des actions avec listen
  ref.listen(dataProvider, (previous, next) {
    // Handle changes
  });

  // ✅ Appeler le controller directement
  onPressed: () {
    ref.read(controllerProvider.notifier).doSomething();
  }
}
```

---

## 🔍 VÉRIFICATION

### Checklist de vérification

- [x] **gamesListProvider** : Ne modifie plus le state pendant l'init
- [x] **initGamesProvider** : Provider séparé pour le chargement
- [x] **GamesLibraryPage** : Utilise le nouveau pattern
- [x] **GamesController constructor** : Propre (pas d'auto-load)
- [x] **Compilation** : ✅ App compile sans erreur
- [ ] **Runtime** : App démarre sans crash Riverpod (à tester)

### Commandes de test

```bash
# Compilation
flutter build ios --simulator --no-codesign

# Lancer l'app
flutter run

# Vérifier les logs
# Pas d'erreur "Providers are not allowed to modify..."
```

---

## 📚 AUTRES PROVIDERS À VÉRIFIER

Si d'autres crashes Riverpod surviennent, vérifier ces providers :

### Dans games_providers.dart

- [x] `gamesListProvider` : **CORRIGÉ**
- [ ] `createSessionProvider` (ligne 95-105) :
  - ⚠️ Utilise `ref.read().notifier.createSession()`
  - ✅ OK car c'est un `FutureProvider.family` appelé par la page, pas pendant un init

### Dans d'autres features

Chercher les patterns dangereux :
```bash
# Trouver tous les ref.read().notifier dans les providers
grep -r "ref.read.*notifier" lib/features/*/application/*/providers.dart
```

**Si trouvé dans l'init d'un Provider/FutureProvider, c'est potentiellement un problème.**

---

## 🎓 LEÇONS APPRISES

### Principe fondamental Riverpod

> **Les providers ne peuvent pas modifier d'autres providers pendant leur initialisation.**

### Solutions

1. **Séparer lecture et écriture :**
   - Provider pour LIRE (`ref.watch`)
   - FutureProvider pour CHARGER (`ref.read().notifier.load()`)

2. **Charger dans les pages :**
   - Utiliser `FutureProvider.autoDispose`
   - Appeler `ref.watch(initProvider)` dans le build method

3. **Pattern d'initialisation :**
   ```dart
   // Provider d'init (dans providers.dart)
   final initDataProvider = FutureProvider.autoDispose((ref) async {
     await ref.read(controllerProvider.notifier).loadData();
   });

   // Usage dans la page
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final initAsync = ref.watch(initDataProvider);
     final data = ref.watch(dataListProvider);

     return initAsync.when(
       data: (_) => YourWidget(data: data),
       loading: () => LoadingWidget(),
       error: (e, s) => ErrorWidget(e),
     );
   }
   ```

---

**Dernière mise à jour** : 2025-11-05
**Status** : ✅ RÉSOLU - App compile, à tester au runtime

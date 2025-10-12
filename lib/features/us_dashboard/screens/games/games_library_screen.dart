import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/us_dashboard/providers/games_provider.dart';
import 'package:lova/features/us_dashboard/screens/games/widgets/game_library_card.dart';
import 'package:lova/features/us_dashboard/models/game.dart';


class GamesLibraryScreen extends ConsumerWidget {
  const GamesLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesLibraryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar avec gradient
          _buildAppBar(context),

          // Contenu
          gamesAsync.when(
            data: (games) => _buildContent(context, ref, games),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Erreur: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '🎴',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bibliothèque de jeux',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Des jeux pour renforcer votre connexion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List games) {
    final availableGames = games.where((g) => g.status == GameStatus.available).toList();
    final upcomingGames = games.where((g) => g.status != GameStatus.available).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 20),

        // Section Disponibles
        if (availableGames.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Disponible maintenant',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...availableGames.map((game) => Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            child: GameLibraryCard(
              game: game,
              onTap: () {
                if (game.id == 'loova_intimacy') {
                  // Incrémenter le compteur
                  ref.read(gamesLibraryProvider.notifier).incrementPlayCount(game.id);
                  // Lancer le jeu
                  context.push('/intimacy-card-game');
                }
              },
              onFavorite: () {
                ref.read(gamesLibraryProvider.notifier).toggleFavorite(game.id);
              },
            ),
          )),
        ],

        // Section À venir
        if (upcomingGames.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Bientôt disponible',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...upcomingGames.map((game) => Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            child: GameLibraryCard(
              game: game,
              onTap: () {
                _showLockedDialog(context, game);
              },
            ),
          )),
        ],

        const SizedBox(height: 100),
      ]),
    );
  }

  void _showLockedDialog(BuildContext context, game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${game.emoji} ${game.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (game.status == GameStatus.comingSoon)
              const Text('Ce jeu sera bientôt disponible ! Restez connecté pour être notifié.')
            else if (game.status == GameStatus.premium)
              const Text('Ce jeu est réservé aux membres Premium. Passez à Premium pour y accéder.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (game.status == GameStatus.premium)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigation vers page Premium
              },
              child: const Text('Voir Premium'),
            ),
        ],
      ),
    );
  }
}
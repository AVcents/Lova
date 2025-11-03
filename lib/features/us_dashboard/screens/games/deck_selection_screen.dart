import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lova/features/us_dashboard/models/game_card_deck.dart';
import 'package:lova/features/us_dashboard/models/game_session.dart';
import 'package:lova/features/us_dashboard/providers/games_provider.dart';

class DeckSelectionScreen extends ConsumerWidget {
  final String gameId;

  const DeckSelectionScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('📦 [DEBUG] DeckSelectionScreen.build - gameId: $gameId');

    final decksAsync = ref.watch(availableDecksProvider(gameId));
    print('📦 [DEBUG] decksAsync state: ${decksAsync.runtimeType}');

    final ownedDecksAsync = ref.watch(ownedDecksProvider);
    print('📦 [DEBUG] ownedDecksAsync state: ${ownedDecksAsync.runtimeType}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un paquet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: decksAsync.when(
        data: (decks) => ownedDecksAsync.when(
          data: (ownedIds) => _buildDeckList(context, ref, decks, ownedIds),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Erreur: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildDeckList(BuildContext context, WidgetRef ref,
      List<GameCardDeck> decks, List<String> ownedIds) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: decks.length,
      itemBuilder: (context, index) {
        final deck = decks[index];
        final isOwned = ownedIds.contains(deck.id);
        final progressAsync = ref.watch(deckProgressProvider(deck.id));

        return progressAsync.when(
          data: (progress) => _buildDeckCard(context, ref, deck, isOwned, progress),
          loading: () => _buildDeckCard(context, ref, deck, isOwned, null),
          error: (e, st) => _buildDeckCard(context, ref, deck, isOwned, null),
        );
      },
    );
  }

  Widget _buildDeckCard(BuildContext context, WidgetRef ref,
      GameCardDeck deck, bool isOwned, progress) {
    return Consumer(
      builder: (context, ref, child) {
        final activeSessionAsync = ref.watch(activeSessionForGameProvider(gameId));
        final hasActiveSession = activeSessionAsync.whenData(
          (session) => session != null,
        ).value ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(deck.deckEmoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deck.deckName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${deck.cardCount} cartes · ${deck.difficultyLevel.name}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isOwned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: deck.isFree ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          deck.isFree ? 'GRATUIT' : '${deck.priceEuros.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  deck.deckDescription,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                if (isOwned && progress != null) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress.completionPercentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: Colors.green,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.cardsCompleted}/${progress.totalCards} cartes complétées',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 12),
                // BOUTON DYNAMIQUE
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleDeckTap(context, ref, deck, isOwned, progress),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasActiveSession ? Colors.green : const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      hasActiveSession ? '🎮 Rejoindre la partie' : '▶️ Jouer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleDeckTap(BuildContext context, WidgetRef ref,
      GameCardDeck deck, bool isOwned, progress) async {
    if (!isOwned) {
      if (deck.isFree) {
        await ref.read(unlockDeckProvider(deck.id).future);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Paquet débloqué !')),
        );
        ref.invalidate(ownedDecksProvider);
        ref.invalidate(deckProgressProvider(deck.id));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paiement à venir')),
        );
      }
      return;
    }

    if (progress?.isLocked == true) {
      _showLockedDialog(context, deck);
      return;
    }

    // Vérifier si une session est déjà active pour ce jeu
    try {
      final session = await ref.read(activeSessionForGameProvider(gameId).future);

      if (!context.mounted) return;

      if (session != null) {
        // Session active → Rejoindre directement
        context.push('/intimacy-card-game/${session.id}');
      } else {
        // Pas de session → Créer
        _showSessionTypeDialog(context, ref, deck);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _showLockedDialog(BuildContext context, GameCardDeck deck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${deck.deckEmoji} Paquet complété !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Vous avez terminé toutes les cartes de ce paquet.'),
            const SizedBox(height: 16),
            Text(
              'Débloquez-le à nouveau pour ${deck.unlockPriceEuros.toStringAsFixed(2)}€',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Paiement déblocage
            },
            child: const Text('Débloquer'),
          ),
        ],
      ),
    );
  }

  void _showSessionTypeDialog(
      BuildContext context, WidgetRef ref, GameCardDeck deck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la durée'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sessionTypeButton(
              context,
              ref,
              deck,
              '⚡ Session rapide',
              '3 cartes (~10 min)',
              SessionType.quick,
            ),
            const SizedBox(height: 12),
            _sessionTypeButton(
              context,
              ref,
              deck,
              '🎯 Session normale',
              '5 cartes (~20 min)',
              SessionType.normal,
            ),
            const SizedBox(height: 12),
            _sessionTypeButton(
              context,
              ref,
              deck,
              '🔥 Session longue',
              '10 cartes (~40 min)',
              SessionType.long,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sessionTypeButton(BuildContext context, WidgetRef ref,
      GameCardDeck deck, String title, String subtitle, SessionType type) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      onTap: () {
        Navigator.pop(context);
        _createSession(context, ref, deck, type);
      },
    );
  }

  Future<void> _createSession(BuildContext context, WidgetRef ref,
      GameCardDeck deck, SessionType type) async {
    print('🎮 [DEBUG] _createSession START');
    print('🎮 [DEBUG] deck.id: ${deck.id}');
    print('🎮 [DEBUG] sessionType: ${type.name}');

    try {
      final params = CreateSessionParams(
        gameId: gameId,
        deckId: deck.id,
        sessionType: type,
      );

      print('🎮 [DEBUG] params created: gameId=${params.gameId}, deckId=${params.deckId}, type=${params.sessionType}');

      final session = await ref.read(createSessionProvider(params).future);

      print('✅ [DEBUG] session created: ${session.id}');

      // INVALIDER pour forcer le reload
      ref.invalidate(activeSessionForGameProvider(gameId));
      ref.invalidate(activeGamesCountProvider);

      if (!context.mounted) return;

      _showInvitationSentDialog(context, session.id);
    } catch (e, stack) {
      print('❌ [DEBUG] _createSession ERROR: $e');
      print('❌ [DEBUG] Stack: $stack');

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _showInvitationSentDialog(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('✉️ Invitation envoyée !'),
        content: const Text(
          'Votre partenaire a reçu une notification. En attente de sa réponse...',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Retour à la bibliothèque
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

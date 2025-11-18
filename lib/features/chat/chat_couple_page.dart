// lib/features/chat/chat_couple_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/core/theme/theme_extensions.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/domain/auth_state.dart';
import 'package:lova/features/chat/providers/couple_chat_provider.dart';
import 'package:lova/features/chat/services/couple_chat_service.dart';
import 'package:lova/features/chat/widgets/chat_couple_app_bar.dart';
import 'package:lova/features/chat/widgets/chat_empty_state_couple.dart';
import 'package:lova/features/chat/widgets/message_bubble_partner.dart';
import 'package:lova/features/chat/widgets/message_bubble_user_couple.dart';
import 'package:lova/features/chat_lova/presentation/widgets/chat_input_bar.dart';
import 'package:lova/features/relation/providers/active_relation_provider.dart';

/// Page principale du Chat Couple
///
/// Affiche la conversation entre toi et ton/ta partenaire avec :
/// - AppBar custom avec dots colorés
/// - Empty state avec suggestions de démarrage
/// - Messages alternés (toi / partenaire)
/// - Input bar réutilisée de LOVA
/// - Scroll auto vers le bas
/// - Highlight de message ciblé (via initialMessageId)
///
/// Usage :
/// ```dart
/// ChatCouplePage(initialMessageId: 123) // Optionnel
/// ```
class ChatCouplePage extends ConsumerStatefulWidget {
  /// ID du message à cibler/scroller au chargement (optionnel)
  final String? initialMessageId;

  const ChatCouplePage({super.key, this.initialMessageId});

  @override
  ConsumerState<ChatCouplePage> createState() => _ChatCouplePageState();
}

class _ChatCouplePageState extends ConsumerState<ChatCouplePage> {
  // Controllers
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // Keys pour le scroll vers message ciblé
  final Map<String, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();

    // Scroll vers le message initial si fourni
    if (widget.initialMessageId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToMessage(widget.initialMessageId!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Scroll automatique vers le bas (dernier message)
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: context.durations.normal,
            curve: context.motion.easeOut,
          );
        }
      });
    }
  }

  /// Scroll vers un message spécifique (pour les bookmarks)
  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );

      // Retire le highlight après animation
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  /// Envoie un message
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Récupérer l'utilisateur connecté
    final currentUser = ref.read(authStateNotifierProvider).userOrNull;
    if (currentUser == null) return;

    // Récupérer la relation active
    final activeRelation = ref.read(activeRelationProvider).value;
    if (activeRelation == null) return;

    final relationId = activeRelation['id'] as String;

    try {
      // Envoyer le message via le service Supabase
      await ref.read(coupleChatServiceProvider).sendMessage(
        relationId: relationId,
        senderId: currentUser.id,
        content: text,
      );

      // Clear le champ de texte
      _textController.clear();

      // Scroll vers le bas
      _scrollToBottom();
    } catch (e) {
      // Gérer l'erreur (par exemple, si c'est le tour du partenaire)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Gère le tap sur une suggestion de l'empty state
  void _handleSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Récupérer l'utilisateur connecté
    final authState = ref.watch(authStateNotifierProvider);
    final currentUser = authState.userOrNull;

    // 2. Récupérer la relation active
    final activeRelationAsync = ref.watch(activeRelationProvider);

    // 3. Gestion des états de chargement et erreurs
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat Couple')),
        body: const Center(
          child: Text('Vous devez être connecté'),
        ),
      );
    }

    return activeRelationAsync.when(
      data: (activeRelation) {
        // Pas de relation active
        if (activeRelation == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chat Couple')),
            body: const Center(
              child: Text('Aucune relation active'),
            ),
          );
        }

        // Récupérer les IDs
        final relationId = activeRelation['id'] as String;
        final partnerId = activeRelation['other_id'] as String;

        // Récupérer les infos du partenaire
        final partnerInfoAsync = ref.watch(partnerInfoProvider(partnerId));

        return partnerInfoAsync.when(
          data: (partnerInfo) {
            // Déterminer le nom d'affichage du partenaire
            final partnerName = partnerInfo?['prenom'] as String? ??
                                partnerInfo?['first_name'] as String? ??
                                partnerInfo?['email'] as String? ??
                                'Partenaire';

            // Construire l'UI du chat
            return _buildChatUI(
              context,
              currentUserId: currentUser.id,
              relationId: relationId,
              partnerId: partnerId,
              partnerName: partnerName,
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(title: const Text('Chat Couple')),
            body: Center(
              child: Text('Erreur: ${error.toString()}'),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Chat Couple')),
        body: Center(
          child: Text('Erreur: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildChatUI(
    BuildContext context, {
    required String currentUserId,
    required String relationId,
    required String partnerId,
    required String partnerName,
  }) {
    final messagesAsync = ref.watch(coupleChatProvider(relationId));

    return messagesAsync.when(
      data: (messages) {
        // Créer les keys pour chaque message
        for (final message in messages) {
          _messageKeys.putIfAbsent(message.id, () => GlobalKey());
        }

        return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatCoupleAppBar(
        coupleId: relationId, // ✅ Utilise le vrai relationId
        scrollToMessage: _scrollToMessage,
      ),
      body: Column(
        children: [
          // Zone de messages (scrollable)
          Expanded(
            child: messages.isEmpty
                ? ChatEmptyStateCouple(
                    onSuggestionTap: _handleSuggestionTap,
                  )
                : Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing.md,
                        vertical: context.spacing.lg,
                      ),
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isTargeted = widget.initialMessageId == message.id;
                        final isFromCurrentUser = message.senderId == currentUserId;

                        return AnimatedContainer(
                          key: _messageKeys[message.id],
                          duration: context.durations.normal,
                          curve: context.motion.easeOut,
                          decoration: isTargeted
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(context.radii.lg),
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    width: 2,
                                  ),
                                )
                              : null,
                          padding: isTargeted
                              ? EdgeInsets.all(context.spacing.sm)
                              : null,
                          child: isFromCurrentUser
                              ? MessageBubbleUserCouple(message: message)
                              : MessageBubblePartner(
                                  message: message,
                                  senderName: partnerName, // ✅ Utilise le vrai nom
                                ),
                        );
                      },
                    ),
                  ),
          ),

          // Input bar
          ChatInputBar(
            controller: _textController,
            onSend: _sendMessage,
            enabled: true,
          ),
        ],
      ),
    );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Chat Couple')),
        body: Center(
          child: Text('Erreur messages: ${error.toString()}'),
        ),
      ),
    );
  }
}
// lib/features/relation/library/library_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:lova/shared/models/message_annotation.dart';
import 'package:lova/shared/providers/annotations_provider.dart';
import 'package:lova/shared/ui/semantic_colors.dart';
import 'package:lova/features/auth/controller/auth_state_notifier.dart';
import 'package:lova/features/auth/domain/auth_state.dart';

class LibraryPage extends ConsumerStatefulWidget {
  final AnnotationTag? initialFilter;
  final String coupleId;
  final Function(String)? scrollToMessage; // UUID String

  const LibraryPage({
    super.key,
    this.initialFilter,
    required this.coupleId,
    this.scrollToMessage,
  });

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  AnnotationTag? _selectedFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Récupérer l'utilisateur connecté
    final authState = ref.watch(authStateNotifierProvider);
    final currentUser = authState.userOrNull;

    // Si pas connecté, afficher erreur
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes tags')),
        body: const Center(child: Text('Vous devez être connecté')),
      );
    }

    // Préparer les paramètres de filtrage (avec userId pour voir SEULEMENT ses tags)
    final filter = AnnotationFilter(
      coupleId: widget.coupleId,
      userId: currentUser.id, // ✅ Filtre par utilisateur connecté
      filter: _selectedFilter,
      query: _searchQuery.isEmpty ? null : _searchQuery,
    );

    // Récupérer les annotations
    final annotationsAsync = ref.watch(annotationsByCoupleProvider(filter));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Mes tags',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: SemanticColors.border(context)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Barre de filtres
          Container(
            color: colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildFilterChip(null, 'Tous'),
                  const SizedBox(width: 8),
                  ...AnnotationTag.values.map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(tag, tag.emoji),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: SemanticColors.border(context),
                  width: 1,
                ),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher dans les notes...',
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: SemanticColors.neutralOnSurface(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: SemanticColors.neutralOnSurface(context),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: SemanticColors.neutralOnSurface(context),
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 1),
                ),
              ),
            ),
          ),

          // Liste des annotations
          Expanded(
            child: annotationsAsync.when(
              data: (annotations) {
                if (annotations.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: annotations.length,
                  itemBuilder: (context, index) {
                    final annotation = annotations[index];
                    return _buildAnnotationCard(annotation);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur de chargement',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: SemanticColors.neutralOnSurface(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AnnotationTag? tag, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _selectedFilter == tag;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedFilter = selected ? tag : null;
        });
      },
      selectedColor: colorScheme.primary.withValues(alpha: 0.2),
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outline.withValues(alpha: 0.15),
        width: isSelected ? 1.5 : 1,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String message = 'Aucun tag trouvé';
    if (_selectedFilter != null) {
      message = 'Aucun tag ${_selectedFilter!.emoji} trouvé';
    }
    if (_searchQuery.isNotEmpty) {
      message = 'Aucun résultat pour "$_searchQuery"';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: SemanticColors.neutralOnSurface(context),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les messages taggés apparaîtront ici',
            style: textTheme.bodyMedium?.copyWith(
              color: SemanticColors.neutralOnSurface(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationCard(MessageAnnotation annotation) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Récupérer l'utilisateur connecté pour déterminer "Toi" vs "Partenaire"
    final authState = ref.watch(authStateNotifierProvider);
    final currentUser = authState.userOrNull;

    // TODO: Récupérer le vrai contenu du message depuis le repository
    // Pour le moment on utilise un placeholder
    const messagePreview = 'Message tagué';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: SemanticColors.border(context), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Fermer la page library
          context.pop();

          // Puis naviguer vers le message dans le chat
          if (widget.scrollToMessage != null) {
            widget.scrollToMessage!(annotation.messageId);
          } else {
            // Naviguer vers le chat avec le messageId en paramètre
            context.push('/chat-couple?messageId=${annotation.messageId}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec emoji et tag
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      annotation.tag.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          annotation.tag.label,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(annotation.createdAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: SemanticColors.neutralOnSurface(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: SemanticColors.neutralOnSurface(context),
                    ),
                    onSelected: (value) async {
                      if (value == 'delete') {
                        await _handleDelete(annotation);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Supprimer',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Aperçu du message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  messagePreview,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Note si présente
              if (annotation.note != null && annotation.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: SemanticColors.neutralOnSurface(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        annotation.note!,
                        style: textTheme.bodySmall?.copyWith(
                          color: SemanticColors.neutralOnSurface(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Actions
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Fermer la page library
                      context.pop();

                      // Puis naviguer vers le message
                      if (widget.scrollToMessage != null) {
                        widget.scrollToMessage!(annotation.messageId);
                      } else {
                        context.push(
                          '/chat-couple?messageId=${annotation.messageId}',
                        );
                      }
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Voir dans le chat'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  if (currentUser != null)
                    Text(
                      annotation.authorUserId == currentUser.id ? 'Tagué par moi' : 'Tagué par mon partenaire',
                      style: textTheme.bodySmall?.copyWith(
                        color: SemanticColors.neutralOnSurface(context),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDelete(MessageAnnotation annotation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce tag ?'),
        content: Text(
          'Le tag "${annotation.tag.label}" sera supprimé de ce message.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      HapticFeedback.lightImpact();
      await ref
          .read(annotationsNotifierProvider.notifier)
          .removeAnnotation(annotation.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tag supprimé'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui à ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE à HH:mm', 'fr_FR').format(date);
    } else {
      return DateFormat('d MMMM à HH:mm', 'fr_FR').format(date);
    }
  }
}

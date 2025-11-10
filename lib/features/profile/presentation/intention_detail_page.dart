// lib/features/profile/presentation/intention_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:lova/features/profile/data/models/life_intention_model.dart';
import 'package:lova/features/profile/providers/intentions_providers.dart';
import 'package:lova/features/profile/presentation/widgets/intention_progress_ring.dart';

class IntentionDetailPage extends ConsumerStatefulWidget {
  final String intentionId;

  const IntentionDetailPage({
    super.key,
    required this.intentionId,
  });

  @override
  ConsumerState<IntentionDetailPage> createState() => _IntentionDetailPageState();
}

class _IntentionDetailPageState extends ConsumerState<IntentionDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final intentionAsync = ref.watch(intentionByIdProvider(widget.intentionId));
    final progressAsync = ref.watch(intentionProgressProvider(widget.intentionId));

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pause',
                child: Row(
                  children: [
                    Icon(Icons.pause_circle_outline),
                    SizedBox(width: 12),
                    Text('Mettre en pause'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 12),
                    Text('Marquer comme complété'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined),
                    SizedBox(width: 12),
                    Text('Archiver'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: intentionAsync.when(
        data: (intention) {
          if (intention == null) {
            return const Center(child: Text('Intention introuvable'));
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec progression
                  _buildHeader(context, intention),

                  const SizedBox(height: 20),

                  // Bouton +1 (si trackable)
                  if (intention.isTrackable && intention.status == IntentionStatus.active)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildAddProgressButton(context, intention),
                    ),

                  const SizedBox(height: 20),

                  // Détails
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildDetailsSection(context, intention),
                  ),

                  const SizedBox(height: 20),

                  // Historique
                  if (intention.isTrackable)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildHistorySection(context, progressAsync),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Erreur de chargement', style: textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LifeIntention intention) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Emoji et catégorie
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Text(
              intention.category.emoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),

          const SizedBox(height: 16),

          // Catégorie et type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${intention.category.label} · ${intention.type.label}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Titre
          Text(
            intention.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          if (intention.description != null) ...[
            const SizedBox(height: 12),
            Text(
              intention.description!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Progression (si trackable)
          if (intention.isTrackable) ...[
            const SizedBox(height: 32),
            IntentionProgressRing(
              progress: intention.progressPercentage,
              size: 120,
              strokeWidth: 12,
            ),
            const SizedBox(height: 16),
            Text(
              intention.progressText,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],

          // Jours restants
          if (intention.daysRemaining != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Il reste ${intention.daysRemaining} jour${intention.daysRemaining! > 1 ? 's' : ''}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],

          // Statut
          if (intention.status != IntentionStatus.active) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(intention.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(intention.status),
                    size: 18,
                    color: _getStatusColor(intention.status),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    intention.status.label,
                    style: TextStyle(
                      color: _getStatusColor(intention.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddProgressButton(BuildContext context, LifeIntention intention) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          HapticFeedback.mediumImpact();

          // Dialog pour saisir une note optionnelle
          final note = await showDialog<String>(
            context: context,
            builder: (context) => _AddProgressDialog(unit: intention.unit),
          );

          if (note == null) return; // Annulé

          final notifier = ref.read(intentionsNotifierProvider.notifier);
          final success = await notifier.addProgress(
            intentionId: intention.id,
            note: note.isEmpty ? null : note,
          );

          if (context.mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(child: Text('✨ Progrès ajouté !')),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.add, size: 24),
        label: Text('Ajouter +1 ${intention.unit ?? ''}'),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, LifeIntention intention) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Début',
            DateFormat('d MMMM yyyy', 'fr_FR').format(intention.startDate),
          ),

          if (intention.endDate != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.event,
              'Fin',
              DateFormat('d MMMM yyyy', 'fr_FR').format(intention.endDate!),
            ),
          ],

          if (intention.frequency != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.repeat,
              'Fréquence',
              intention.frequency!,
            ),
          ],

          if (intention.autoTrack && intention.linkedRitualTypes.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.link,
              'Rituels liés',
              intention.linkedRitualTypes.join(', '),
            ),
          ],

          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            Icons.update,
            'Créée le',
            DateFormat('d MMMM yyyy', 'fr_FR').format(intention.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          '$label : ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(
      BuildContext context,
      AsyncValue<List<dynamic>> progressAsync,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historique',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        progressAsync.when(
          data: (progressList) {
            if (progressList.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Aucun progrès enregistré',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: progressList.take(10).map((progress) {
                  final date = DateTime.parse(progress.progressDate.toString());
                  final isAuto = progress.source == 'auto_ritual';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isAuto
                                ? Colors.blue.withOpacity(0.1)
                                : colorScheme.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isAuto ? Icons.auto_awesome : Icons.edit,
                            size: 16,
                            color: isAuto ? Colors.blue : colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE d MMMM', 'fr_FR').format(date),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (progress.note != null)
                                Text(
                                  progress.note,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '+${progress.incrementValue}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) async {
    final notifier = ref.read(intentionsNotifierProvider.notifier);

    switch (action) {
      case 'pause':
        final confirmed = await _showConfirmDialog(
          context,
          'Mettre en pause',
          'Voulez-vous mettre cette intention en pause ?',
        );
        if (confirmed) {
          await notifier.updateStatus(widget.intentionId, IntentionStatus.paused);
          if (context.mounted) context.pop();
        }
        break;

      case 'complete':
        final confirmed = await _showConfirmDialog(
          context,
          'Marquer comme complété',
          'Cette intention sera marquée comme complétée.',
        );
        if (confirmed) {
          await notifier.updateStatus(widget.intentionId, IntentionStatus.completed);
          if (context.mounted) context.pop();
        }
        break;

      case 'archive':
        final confirmed = await _showConfirmDialog(
          context,
          'Archiver',
          'Cette intention sera archivée.',
        );
        if (confirmed) {
          await notifier.updateStatus(widget.intentionId, IntentionStatus.archived);
          if (context.mounted) context.pop();
        }
        break;

      case 'delete':
        final confirmed = await _showConfirmDialog(
          context,
          'Supprimer',
          'Cette action est irréversible. Toutes les données seront perdues.',
          isDestructive: true,
        );
        if (confirmed) {
          await notifier.deleteIntention(widget.intentionId);
          if (context.mounted) context.pop();
        }
        break;
    }
  }

  Future<bool> _showConfirmDialog(
      BuildContext context,
      String title,
      String message, {
        bool isDestructive = false,
      }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: isDestructive ? Colors.red : null,
            ),
            child: Text(isDestructive ? 'Supprimer' : 'Confirmer'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Color _getStatusColor(IntentionStatus status) {
    switch (status) {
      case IntentionStatus.active:
        return Colors.green;
      case IntentionStatus.completed:
        return Colors.blue;
      case IntentionStatus.paused:
        return Colors.orange;
      case IntentionStatus.archived:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(IntentionStatus status) {
    switch (status) {
      case IntentionStatus.active:
        return Icons.play_circle_outline;
      case IntentionStatus.completed:
        return Icons.check_circle;
      case IntentionStatus.paused:
        return Icons.pause_circle_outline;
      case IntentionStatus.archived:
        return Icons.archive;
    }
  }
}

// Dialog pour ajouter une note lors du progrès
class _AddProgressDialog extends StatefulWidget {
  final String? unit;

  const _AddProgressDialog({this.unit});

  @override
  State<_AddProgressDialog> createState() => _AddProgressDialogState();
}

class _AddProgressDialogState extends State<_AddProgressDialog> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Ajouter +1 ${widget.unit ?? ''}'),
      content: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          hintText: 'Note optionnelle...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        maxLength: 200,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _noteController.text),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
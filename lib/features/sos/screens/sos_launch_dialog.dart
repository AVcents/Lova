import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/sos_provider.dart';

class SosLaunchDialog extends ConsumerStatefulWidget {
  const SosLaunchDialog({super.key});

  @override
  ConsumerState<SosLaunchDialog> createState() => _SosLaunchDialogState();
}

class _SosLaunchDialogState extends ConsumerState<SosLaunchDialog> {
  int _intensity = 3;
  String? _conflictTopic;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  final List<String> _topics = [
    'Communication',
    'Tâches ménagères',
    'Intimité',
    'Finances',
    'Famille/Amis',
    'Autre',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _launchSos() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Décrivez brièvement la situation')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sb = Supabase.instance.client;
      final userId = sb.auth.currentUser!.id;

      // Get relation_id (prendre la première)
      final members = await sb
          .from('relation_members')
          .select('relation_id')
          .eq('user_id', userId)
          .limit(1);

      if (members.isEmpty) {
        throw Exception('Aucune relation trouvée');
      }

      final relationId = members.first['relation_id'] as String;

      // Créer session
      final service = ref.read(sosServiceProvider);
      final session = await service.createSession(
        relationId: relationId,
        initiatedBy: userId,
        initialEmotion: 'frustrated', // TODO: sélection émotion
        initialDescription: _descriptionController.text.trim(),
        intensityLevel: _intensity,
        conflictTopic: _conflictTopic,
      );

      if (mounted) {
        context.pop();
        // Redirect vers chat en mode médiation
        context.push('/chat-couple?sos_session=${session.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Row(
        children: [
          Text('🆘'),
          SizedBox(width: 8),
          Text('Lancer SOS Couple'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LOOVA va vous aider à désamorcer la tension. Les deux partenaires seront invités à rejoindre la médiation.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),

            // Intensité
            Text('Intensité de la tension', style: theme.textTheme.titleSmall),
            Slider(
              value: _intensity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: _intensity.toString(),
              onChanged: (v) => setState(() => _intensity = v.toInt()),
            ),

            const SizedBox(height: 16),

            // Sujet (optionnel)
            Text('Sujet (optionnel)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _topics.map((topic) {
                final isSelected = _conflictTopic == topic;
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _conflictTopic = selected ? topic : null);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Décrivez brièvement',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => context.pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _launchSos,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Lancer la médiation'),
        ),
      ],
    );
  }
}

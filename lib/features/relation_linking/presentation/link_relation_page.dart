import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:lova/features/relation_linking/application/link_relation_controller.dart';
import 'package:lova/features/relation_linking/domain/relation_linking_state.dart';
import 'package:lova/features/relation_linking/infrastructure/linking_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider pour surveiller la relation active en temps réel
final activeRelationProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final repository = ref.watch(linkingRepositoryProvider);
  return repository.activeRelationStream().map((list) {
    return list.isEmpty ? null : list.first;
  });
});

// Provider pour le repository
final linkingRepositoryProvider = Provider<LinkingRepository>((ref) {
  return LinkingRepository(Supabase.instance.client);
});

// Provider pour récupérer les infos du partenaire
final partnerInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, partnerId) async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select('id, first_name, prenom, email, avatar_url')
        .eq('id', partnerId)
        .single();
    return response;
  } catch (e) {
    print('Erreur récupération partenaire: $e');
    return null;
  }
});

class LinkRelationPage extends ConsumerStatefulWidget {
  const LinkRelationPage({super.key});

  @override
  ConsumerState<LinkRelationPage> createState() => _LinkRelationPageState();
}

class _LinkRelationPageState extends ConsumerState<LinkRelationPage> {
  final TextEditingController _codeController = TextEditingController();

  Timer? _timer;
  String? _generatedCode;
  DateTime? _expiresAt;

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _submitLinkRequest() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    // Dialogue pour choisir le type de relation
    final relationMode = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Type de relation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choisissez le type de relation avec votre partenaire :'),
            const SizedBox(height: 16),
            _buildRelationModeOption(context, 'dating', 'En couple', Icons.favorite),
            _buildRelationModeOption(context, 'engaged', 'Fiancés', Icons.diamond),
            _buildRelationModeOption(context, 'married', 'Mariés', Icons.favorite_border),
            _buildRelationModeOption(context, 'civil_union', 'PACS', Icons.gavel),
            _buildRelationModeOption(context, 'common_law', 'Union libre', Icons.handshake),
          ],
        ),
      ),
    );

    if (relationMode == null) return;

    try {
      await ref.read(linkRelationControllerProvider.notifier).linkWithCode(code, relationMode);
    } catch (e, _) {
      _showError(e);
    }
  }

  Widget _buildRelationModeOption(BuildContext context, String value, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      onTap: () => Navigator.pop(context, value),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    if (_expiresAt == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_expiresAt!.isBefore(DateTime.now())) {
        _timer?.cancel();
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }

  void _showError(Object e) {
    final msg = e.toString();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, maxLines: 3)),
    );
  }

  Future<void> _generateCode() async {
    try {
      final res = await ref.read(linkRelationControllerProvider.notifier).generateCode();
      setState(() {
        _generatedCode = res.code;
        _expiresAt = res.expiresAt;
      });
      _startCountdown();
    } on PostgrestException catch (e) {
      _showError('${e.code ?? ''} ${e.message}');
    } catch (e, _) {
      _showError(e);
    }
  }

  Future<void> _revokeRelation(String relationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dissocier la relation'),
        content: const Text(
          'Êtes-vous sûr de vouloir dissocier cette relation ? '
              'Votre partenaire ne sera plus lié à votre compte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Dissocier'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repository = ref.read(linkingRepositoryProvider);
        await repository.revoke(relationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Relation dissociée avec succès')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(linkRelationControllerProvider);
    final activeRelationAsync = ref.watch(activeRelationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Lier mon compte partenaire")),
      body: activeRelationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: ${error.toString()}'),
        ),
        data: (activeRelation) {
          // Si une relation active existe
          if (activeRelation != null) {
            final relationId = activeRelation['id'] as String;
            final otherId = activeRelation['other_id'] as String?;

            if (otherId == null) {
              return const Center(child: Text('Erreur: partenaire non trouvé'));
            }

            // Récupérer les infos du partenaire
            final partnerAsync = ref.watch(partnerInfoProvider(otherId));

            return partnerAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Erreur chargement partenaire: ${error.toString()}'),
              ),
              data: (partner) {
                final partnerName = partner?['first_name'] ??
                    partner?['prenom'] ??
                    partner?['email'] ??
                    'Partenaire';

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Vous êtes en couple avec',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        partnerName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 40),
                            SizedBox(height: 8),
                            Text(
                              'Relation active',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Vous pouvez utiliser toutes les fonctionnalités de couple',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => _revokeRelation(relationId),
                        icon: const Icon(Icons.link_off),
                        label: const Text('Dissocier cette relation'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // Pas de relation active - afficher l'interface de linking
          return _buildLinkingInterface(state);
        },
      ),
    );
  }

  Widget _buildLinkingInterface(RelationLinkingState state) {
    String remaining() {
      if (_expiresAt == null) return '';
      final diff = _expiresAt!.difference(DateTime.now());
      if (diff.isNegative) return 'Expiré';
      final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.status == RelationLinkingStatus.linked)
            const Text(
              "🎉 Vous êtes maintenant liés !",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          else ...[
            const Text(
              "Entrez le code d'invitation fourni par votre partenaire :",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Code d'invitation",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.status == RelationLinkingStatus.pending
                  ? null
                  : _submitLinkRequest,
              child: state.status == RelationLinkingStatus.pending
                  ? const CircularProgressIndicator()
                  : const Text("Lier"),
            ),
            const SizedBox(height: 16),
            if (state.status == RelationLinkingStatus.error &&
                state.message != null)
              Text(
                state.message!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Ou générez un code à partager :",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: state.status == RelationLinkingStatus.pending
                  ? null
                  : _generateCode,
              child: state.status == RelationLinkingStatus.pending
                  ? const CircularProgressIndicator()
                  : const Text("Générer un code"),
            ),
            if (_generatedCode != null) ...[
              const SizedBox(height: 16),
              Text(
                _generatedCode!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _expiresAt == null ? '' : 'Expire dans ${remaining()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final code = _generatedCode;
                    if (code == null) return;
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copié dans le presse-papiers')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copier le code'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
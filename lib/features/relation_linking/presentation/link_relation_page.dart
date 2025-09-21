import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:lova/features/relation_linking/application/link_relation_controller.dart';
import 'package:lova/features/relation_linking/domain/relation_linking_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    try {
      await ref.read(linkRelationControllerProvider.notifier).linkWithCode(code);
    } catch (e, _) {
      _showError(e);
    }
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(linkRelationControllerProvider);

    String remaining() {
      if (_expiresAt == null) return '';
      final diff = _expiresAt!.difference(DateTime.now());
      if (diff.isNegative) return 'Expiré';
      final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Lier mon compte partenaire")),
      body: Padding(
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
                "Entrez le code d’invitation fourni par votre partenaire :",
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
                onPressed: state.status == RelationLinkingStatus.pending ? null : _generateCode,
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
                        const SnackBar(content: Text('Code copié dans le presse‑papiers')),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/link_relation_controller.dart';
import '../domain/relation_linking_state.dart';

class LinkRelationPage extends ConsumerStatefulWidget {
  const LinkRelationPage({super.key});

  @override
  ConsumerState<LinkRelationPage> createState() => _LinkRelationPageState();
}

class _LinkRelationPageState extends ConsumerState<LinkRelationPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submitLinkRequest() {
    final code = _codeController.text.trim();

    // TODO: remplacer par l’ID réel de l’utilisateur connecté
    const currentUserId = "user_b";

    ref.read(linkRelationControllerProvider.notifier).linkWithCode(code, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(linkRelationControllerProvider);

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
              if (state.status == RelationLinkingStatus.error && state.message != null)
                Text(
                  state.message!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
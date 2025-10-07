import 'package:flutter/material.dart';
import 'package:lova/services/storage_service.dart';

class StorageTestPage extends StatefulWidget {
  const StorageTestPage({super.key});

  @override
  State<StorageTestPage> createState() => _StorageTestPageState();
}

class _StorageTestPageState extends State<StorageTestPage> {
  String? avatarUrl;
  String? relationUrl;
  bool loadingAvatar = false;
  bool loadingRelation = false;
  String? avatarErr;
  String? relationErr;

  Future<void> _loadAvatar() async {
    setState(() {
      loadingAvatar = true;
      avatarErr = null;
      avatarUrl = null;
    });
    try {
      final url = await signMyAvatar(expiresSec: 60);
      if (url == null) {
        setState(() => avatarErr = 'Aucune URL (pas de session, pas d\'avatar ou RLS bloque).');
      } else {
        setState(() => avatarUrl = url);
      }
    } catch (e) {
      setState(() => avatarErr = 'Erreur: $e');
    } finally {
      if (mounted) setState(() => loadingAvatar = false);
    }
  }

  Future<void> _loadRelationMedia() async {
    setState(() {
      loadingRelation = true;
      relationErr = null;
      relationUrl = null;
    });
    try {
      const relationId = '8272082a-076e-4a7d-99b4-0857d3ac7423';
      final url = await signRelationMedia(
        relationId: relationId,
        objectPath: 'photos/test.png',
        expiresSec: 120,
      );
      if (url == null) {
        setState(() => relationErr = 'Aucune URL (pas de session, objet absent ou RLS bloque).');
      } else {
        setState(() => relationUrl = url);
      }
    } catch (e) {
      setState(() => relationErr = 'Erreur: $e');
    } finally {
      if (mounted) setState(() => loadingRelation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Storage")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loadAvatar,
              child: const Text("Charger avatar signé"),
            ),
            if (loadingAvatar) const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(),
            ),
            if (avatarErr != null) Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(avatarErr!, style: TextStyle(color: Colors.red)),
            ),
            if (avatarUrl != null) ...[
              const SizedBox(height: 8),
              SelectableText(avatarUrl!),
              const SizedBox(height: 8),
              // Affiche l'image seulement si c'est une image; sinon l'appel échouera silencieusement.
              Image.network(avatarUrl!, errorBuilder: (_, __, ___) => const Text('URL signée OK (non-image).')),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadRelationMedia,
              child: const Text("Charger media de relation"),
            ),
            if (loadingRelation) const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(),
            ),
            if (relationErr != null) Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(relationErr!, style: TextStyle(color: Colors.red)),
            ),
            if (relationUrl != null) ...[
              const SizedBox(height: 8),
              SelectableText(relationUrl!),
              const SizedBox(height: 8),
              Image.network(relationUrl!, errorBuilder: (_, __, ___) => const Text('URL signée OK (non-image).')),
            ],
          ],
        ),
      ),
    );
  }
}
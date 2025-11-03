// lib/features/notifications/test_notification_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestNotificationPage extends StatefulWidget {
  const TestNotificationPage({super.key});

  @override
  State<TestNotificationPage> createState() => _TestNotificationPageState();
}

class _TestNotificationPageState extends State<TestNotificationPage> {
  final _titleController = TextEditingController(text: 'Test Notification');
  final _bodyController = TextEditingController(text: 'Ceci est un message de test');
  bool _isLoading = false;
  String? _result;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      _showResult('Erreur: Utilisateur non connecté', isError: true);
      return;
    }

    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      _showResult('Erreur: Titre et message requis', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-notification',
        body: {
          'user_id': userId,
          'title': _titleController.text,
          'body': _bodyController.text,
          'data': {'type': 'test'}
        },
      );

      if (mounted) {
        if (response.status == 200) {
          _showResult('✅ Notification envoyée avec succès!\n\nRéponse: ${response.data}');
        } else {
          _showResult('❌ Erreur ${response.status}: ${response.data}', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showResult('❌ Erreur: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showResult(String message, {bool isError = false}) {
    setState(() => _result = message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Test Edge Function',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Envoyez une notification de test à vous-même',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'User ID: ${userId ?? "Non connecté"}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre de la notification',
                hintText: 'Entrez le titre',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              maxLength: 50,
            ),

            const SizedBox(height: 16),

            // Body TextField
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Entrez le message de la notification',
                prefixIcon: const Icon(Icons.message),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              maxLines: 4,
              maxLength: 200,
            ),

            const SizedBox(height: 24),

            // Send Button
            FilledButton.icon(
              onPressed: _isLoading ? null : _sendNotification,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_isLoading ? 'Envoi en cours...' : 'Envoyer la notification'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Result Display
            if (_result != null)
              Card(
                color: _result!.contains('❌')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _result!.contains('❌')
                                ? Icons.error
                                : Icons.check_circle,
                            color: _result!.contains('❌')
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Résultat',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _result!,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cette page teste l\'Edge Function "send-notification". '
                            'Assurez-vous que :\n'
                            '• Vous avez un FCM token enregistré\n'
                            '• L\'Edge Function est déployée\n'
                            '• Votre appareil autorise les notifications',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

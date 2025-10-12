import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectionGamesScreen extends StatelessWidget {
  const ConnectionGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeux de connexion'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎴', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              'Jeux de connexion',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text('(En construction)'),
          ],
        ),
      ),
    );
  }
}
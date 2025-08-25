import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class MediationFlowPage extends StatefulWidget {
  const MediationFlowPage({super.key});

  @override
  State<MediationFlowPage> createState() => _MediationFlowPageState();
}

class _MediationFlowPageState extends State<MediationFlowPage> {
  int _currentStep = 0;

  final List<String> _steps = [
    "🧘 Étape 1 : Respirez profondément.\nPrenez quelques secondes pour vous recentrer.",
    "🗣️ Étape 2 : Chacun s’exprime à tour de rôle.\nExprimez calmement ce que vous ressentez, sans accuser.",
    "🤝 Étape 3 : Trouvez une action concrète.\nChoisissez ensemble une chose simple à faire pour apaiser la tension.",
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _restartFlow() {
    setState(() {
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médiation guidée'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _steps[_currentStep],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _currentStep < _steps.length - 1 ? _nextStep : _restartFlow,
              child: Text(_currentStep < _steps.length - 1 ? 'Étape suivante' : 'Recommencer'),
            ),
          ],
        ),
      ),
    );
  }
}
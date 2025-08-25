import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova/core/providers/database_provider.dart';

class WeeklyCheckinPage extends ConsumerStatefulWidget {
  const WeeklyCheckinPage({super.key});

  @override
  ConsumerState<WeeklyCheckinPage> createState() => _WeeklyCheckinPageState();
}

class _WeeklyCheckinPageState extends ConsumerState<WeeklyCheckinPage> {
  int? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'value': 1},
    {'emoji': '😐', 'value': 2},
    {'emoji': '🙂', 'value': 3},
    {'emoji': '😊', 'value': 4},
    {'emoji': '🥰', 'value': 5},
  ];

  void _submitMood() async {
    if (_selectedMood != null) {
      final db = ref.read(databaseProvider);
      await db.insertWeeklyCheckin(_selectedMood!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Merci pour votre réponse ❤️")),
      );
      context.go('/dashboard');
    }
  }

  void _debugPrintAllCheckins() async {
    final db = ref.read(databaseProvider);
    final checkins = await db.getAllCheckins();

    for (final checkin in checkins) {
      print("📝 Check-in => ID: ${checkin.id}, Mood: ${checkin.mood}, Date: ${checkin.timestamp}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check-in relationnel"),
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
            const Text(
              "Petit check-in 💬\nComment va votre couple aujourd’hui ?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: _moods.map((mood) {
                final selected = _selectedMood == mood['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['value'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? Colors.teal.withOpacity(0.2) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.teal : Colors.grey,
                        width: selected ? 3 : 1,
                      ),
                    ),
                    child: Text(
                      mood['emoji'],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _selectedMood != null ? _submitMood : null,
              child: const Text("Valider"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _debugPrintAllCheckins,
              child: const Text("📋 Voir les check-ins (console)"),
            ),
          ],
        ),
      ),
    );
  }
}
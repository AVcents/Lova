import 'package:flutter/material.dart';
import 'suggestion_repository.dart';

class Suggestion {
  final String type;
  final String title;
  final String description;

  Suggestion({required this.type, required this.title, required this.description});
}

class SuggestionsList extends StatefulWidget {
  const SuggestionsList({super.key});

  @override
  State<SuggestionsList> createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  List<Suggestion>? _suggestions;

  final Set<int> _ignoredIndices = {};
  final Set<int> _acceptedIndices = {};

  @override
  void initState() {
    super.initState();
    loadSuggestions();
  }

  void loadSuggestions() async {
    final repo = SuggestionRepository();
    final data = await repo.fetchSuggestions();
    setState(() {
      _suggestions = data;
    });
  }

  void _acceptSuggestion(int index) {
    setState(() {
      _acceptedIndices.add(index);
    });
  }

  void _ignoreSuggestion(int index) {
    setState(() {
      _ignoredIndices.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      body: _suggestions == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _suggestions!.length,
              itemBuilder: (context, index) {
                if (_ignoredIndices.contains(index)) return const SizedBox.shrink();

                final suggestion = _suggestions![index];
                final isAccepted = _acceptedIndices.contains(index);

                return Card(
                  color: isAccepted ? Colors.green[50] : null,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(suggestion.title),
                    subtitle: Text(suggestion.description),
                    trailing: isAccepted
                        ? const Icon(Icons.check, color: Colors.green)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _ignoreSuggestion(index),
                                tooltip: 'Ignorer',
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () => _acceptSuggestion(index),
                                tooltip: 'Accepter',
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
    );
  }
}
import 'suggestions_list.dart';

class SuggestionRepository {
  static final List<Suggestion> mockData = [
    Suggestion(
      type: 'sortie',
      title: 'Sortie au parc',
      description: 'Profitez d’une promenade dans un parc proche de chez vous.',
    ),
    Suggestion(
      type: 'activité',
      title: 'Soirée jeux de société',
      description: 'Organisez une soirée jeux de société à deux.',
    ),
    Suggestion(
      type: 'rituel',
      title: 'Rituel du dimanche matin',
      description: 'Petit déjeuner ensemble sans écrans.',
    ),
  ];

  Future<List<Suggestion>> fetchSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simule un appel réseau
    return mockData;
  }
}
// lib/features/me_dashboard/data/monthly_analysis_service.dart

import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class MonthlyAnalysisService {
  final SupabaseClient _supabase;

  MonthlyAnalysisService(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  /// Générer l'analyse du mois écoulé (à appeler le 1er du mois via cron/cloud function)
  Future<void> generateMonthlyAnalysis({
    required int year,
    required int month,
  }) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    // 1. Récupérer tous les check-ins du mois
    final checkins = await _getCheckinsForMonth(year, month);

    if (checkins.isEmpty) {
      print('No check-ins for $month/$year, skipping analysis');
      return;
    }

    // 2. Calculer les statistiques
    final stats = _calculateStats(checkins);

    // 3. Récupérer les actions/rituels du mois
    final actions = await _getActionsForMonth(year, month);

    // 4. Analyser les corrélations
    final correlations = _analyzeCorrelations(checkins, actions);

    // 5. Générer l'analyse IA via Claude API
    final aiInsight = await _generateAIInsight(
      stats: stats,
      correlations: correlations,
      month: month,
      year: year,
    );

    // 6. Déterminer le sentiment général
    final sentiment = _determineSentiment(stats);

    // 7. Créer un résumé court pour la card dashboard
    final shortSummary = _generateShortSummary(stats, sentiment);

    // 8. Sauvegarder l'analyse en base
    await _saveAnalysis(
      year: year,
      month: month,
      stats: stats,
      sentiment: sentiment,
      shortSummary: shortSummary,
      aiInsight: aiInsight,
      correlations: correlations,
    );
  }

  /// Récupérer les check-ins d'un mois spécifique
  Future<List<Map<String, dynamic>>> _getCheckinsForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final response = await _supabase
        .from('me_checkins')
        .select()
        .eq('user_id', _currentUserId!)
        .gte('ts', startDate.toIso8601String())
        .lte('ts', endDate.toIso8601String())
        .order('ts', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Récupérer les actions/rituels d'un mois spécifique
  Future<List<Map<String, dynamic>>> _getActionsForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final response = await _supabase
        .from('me_actions')
        .select()
        .eq('user_id', _currentUserId!)
        .gte('ts', startDate.toIso8601String())
        .lte('ts', endDate.toIso8601String())
        .order('ts', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Calculer les statistiques du mois
  Map<String, dynamic> _calculateStats(List<Map<String, dynamic>> checkins) {
    if (checkins.isEmpty) {
      return {
        'checkin_count': 0,
        'average_mood': 0.0,
        'positive_days': 0,
        'neutral_days': 0,
        'difficult_days': 0,
        'top_triggers': [],
        'mood_distribution': {},
      };
    }

    final moods = checkins.map((c) => c['mood'] as int).toList();
    final averageMood = moods.reduce((a, b) => a + b) / moods.length;

    final positiveDays = moods.where((m) => m >= 4).length;
    final neutralDays = moods.where((m) => m == 3 || m == 2).length;
    final difficultDays = moods.where((m) => m == 1).length;

    // Compter les déclencheurs
    final triggerCount = <String, int>{};
    for (final checkin in checkins) {
      final trigger = checkin['trigger'] as String?;
      if (trigger != null && trigger.isNotEmpty) {
        triggerCount[trigger] = (triggerCount[trigger] ?? 0) + 1;
      }
    }

    // Trier par fréquence
    final topTriggers = triggerCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Distribution des humeurs
    final moodDistribution = <int, int>{};
    for (final mood in moods) {
      moodDistribution[mood] = (moodDistribution[mood] ?? 0) + 1;
    }

    return {
      'checkin_count': checkins.length,
      'average_mood': averageMood,
      'positive_days': positiveDays,
      'neutral_days': neutralDays,
      'difficult_days': difficultDays,
      'top_triggers': topTriggers.take(5).map((e) => {
        'name': e.key,
        'count': e.value,
      }).toList(),
      'mood_distribution': moodDistribution,
    };
  }

  /// Analyser les corrélations entre rituels et humeur
  Map<String, dynamic> _analyzeCorrelations(
      List<Map<String, dynamic>> checkins,
      List<Map<String, dynamic>> actions,
      ) {
    // Créer un map des jours avec rituels
    final daysWith = <String, List<String>>{};
    for (final action in actions) {
      final date = DateTime.parse(action['ts'] as String);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      daysWith[dateKey] ??= [];
      daysWith[dateKey]!.add(action['type'] as String);
    }

    // Calculer l'humeur moyenne les jours avec/sans rituels
    final moodsWithRituals = <int>[];
    final moodsWithoutRituals = <int>[];

    for (final checkin in checkins) {
      final date = DateTime.parse(checkin['ts'] as String);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      final mood = checkin['mood'] as int;

      if (daysWith.containsKey(dateKey) && daysWith[dateKey]!.isNotEmpty) {
        moodsWithRituals.add(mood);
      } else {
        moodsWithoutRituals.add(mood);
      }
    }

    final avgWithRituals = moodsWithRituals.isEmpty
        ? 0.0
        : moodsWithRituals.reduce((a, b) => a + b) / moodsWithRituals.length;

    final avgWithoutRituals = moodsWithoutRituals.isEmpty
        ? 0.0
        : moodsWithoutRituals.reduce((a, b) => a + b) / moodsWithoutRituals.length;

    // Compter les types de rituels et leur impact
    final ritualImpact = <String, List<int>>{};
    for (final action in actions) {
      final type = action['type'] as String;
      final date = DateTime.parse(action['ts'] as String);
      final dateKey = '${date.year}-${date.month}-${date.day}';

      // Trouver le check-in du même jour
      final dayCheckin = checkins.where((c) {
        final cDate = DateTime.parse(c['ts'] as String);
        final cDateKey = '${cDate.year}-${cDate.month}-${cDate.day}';
        return cDateKey == dateKey;
      }).toList();

      if (dayCheckin.isNotEmpty) {
        ritualImpact[type] ??= [];
        ritualImpact[type]!.add(dayCheckin.first['mood'] as int);
      }
    }

    // Calculer l'humeur moyenne par type de rituel
    final ritualAverages = <String, double>{};
    ritualImpact.forEach((type, moods) {
      if (moods.isNotEmpty) {
        ritualAverages[type] = moods.reduce((a, b) => a + b) / moods.length;
      }
    });

    return {
      'days_with_rituals': moodsWithRituals.length,
      'days_without_rituals': moodsWithoutRituals.length,
      'avg_mood_with_rituals': avgWithRituals,
      'avg_mood_without_rituals': avgWithoutRituals,
      'impact_difference': avgWithRituals - avgWithoutRituals,
      'ritual_averages': ritualAverages,
      'total_ritual_minutes': actions.fold<int>(
        0,
            (sum, action) => sum + (action['duration_min'] as int? ?? 0),
      ),
    };
  }

  /// Générer l'analyse IA via OpenAI API
  Future<String> _generateAIInsight({
    required Map<String, dynamic> stats,
    required Map<String, dynamic> correlations,
    required int month,
    required int year,
  }) async {
    final monthName = _getMonthName(month);

    final prompt = '''
Vous êtes Loova, un compagnon bienveillant d'accompagnement au bien-être. Analysez les données suivantes du mois de $monthName $year pour cet utilisateur et générez un résumé factuel et encourageant.

Données du mois :
- ${stats['checkin_count']} check-ins effectués
- Humeur moyenne : ${stats['average_mood'].toStringAsFixed(1)}/5
- ${stats['positive_days']} jours positifs (humeur 4-5)
- ${stats['neutral_days']} jours neutres (humeur 2-3)
- ${stats['difficult_days']} jours difficiles (humeur 1)

Déclencheurs principaux :
${stats['top_triggers'].map((t) => '- ${t['name']} : ${t['count']} fois').join('\n')}

Rituels et impact :
- ${correlations['days_with_rituals']} jours avec rituels (humeur moyenne : ${correlations['avg_mood_with_rituals'].toStringAsFixed(1)})
- ${correlations['days_without_rituals']} jours sans rituels (humeur moyenne : ${correlations['avg_mood_without_rituals'].toStringAsFixed(1)})
- Différence d'impact : ${(correlations['impact_difference'] > 0 ? '+' : '')}${correlations['impact_difference'].toStringAsFixed(1)}
- Total : ${correlations['total_ritual_minutes']} minutes de rituels

Générez un résumé en 3-4 paragraphes qui :
1. Résume objectivement le mois (pas de jugement)
2. Identifie des patterns observables
3. Souligne les corrélations entre rituels et humeur
4. Suggère des pistes concrètes (pas de diagnostic)

IMPORTANT :
- Rester factuel et bienveillant
- Ne jamais diagnostiquer ou profiler psychologiquement
- Toujours inclure des éléments positifs
- Suggestions d'actions, pas de jugements
- Maximum 400 mots
''';

    try {
      // Appel via Edge Function Supabase
      final response = await _supabase.functions.invoke(
        'generate-monthly-insight',
        body: {'prompt': prompt},
      );

      if (response.data != null && response.data['insight'] != null) {
        return response.data['insight'] as String;
      } else {
        throw Exception('Invalid response from AI service');
      }
    } catch (e) {
      print('Error generating AI insight: $e');
      return _generateFallbackInsight(stats, correlations);
    }
  }
  /// Générer un résumé de secours si Claude API échoue
  String _generateFallbackInsight(
      Map<String, dynamic> stats,
      Map<String, dynamic> correlations,
      ) {
    final avgMood = stats['average_mood'] as double;
    String sentiment;

    if (avgMood >= 3.5) {
      sentiment = 'Ce mois a été globalement positif';
    } else if (avgMood >= 2.5) {
      sentiment = 'Ce mois a présenté des hauts et des bas';
    } else {
      sentiment = 'Ce mois a été plus difficile';
    }

    return '''
$sentiment avec ${stats['checkin_count']} check-ins effectués et une humeur moyenne de ${avgMood.toStringAsFixed(1)}/5.

${stats['positive_days']} jours ont été marqués par une humeur positive. Les déclencheurs les plus fréquents étaient ${(stats['top_triggers'] as List).take(2).map((t) => t['name']).join(' et ')}.

${correlations['impact_difference'] > 0.5 ? 'Les jours avec rituels montrent une amélioration notable de l\'humeur (+${correlations['impact_difference'].toStringAsFixed(1)} points en moyenne).' : 'Continuer les rituels quotidiens peut aider à maintenir un bien-être stable.'}

Pour le mois prochain, maintenir une pratique régulière des rituels et rester attentif aux déclencheurs identifiés peut être bénéfique.
''';
  }

  /// Déterminer le sentiment général du mois
  String _determineSentiment(Map<String, dynamic> stats) {
    final avgMood = stats['average_mood'] as double;
    final positiveDays = stats['positive_days'] as int;
    final totalDays = stats['checkin_count'] as int;

    if (avgMood >= 3.5 || (positiveDays / totalDays) >= 0.6) {
      return 'positive';
    } else if (avgMood <= 2.5 || (positiveDays / totalDays) <= 0.3) {
      return 'difficult';
    } else {
      return 'neutral';
    }
  }

  /// Générer un résumé court pour la card
  String _generateShortSummary(Map<String, dynamic> stats, String sentiment) {
    final count = stats['checkin_count'] as int;
    final positiveDays = stats['positive_days'] as int;

    switch (sentiment) {
      case 'positive':
        return '$count check-ins effectués, $positiveDays jours positifs. Une belle période globalement.';
      case 'difficult':
        return '$count check-ins effectués. Période plus challengeante avec des hauts et des bas.';
      default:
        return '$count check-ins effectués. Mois stable avec $positiveDays jours positifs.';
    }
  }

  /// Sauvegarder l'analyse en base de données
  Future<void> _saveAnalysis({
    required int year,
    required int month,
    required Map<String, dynamic> stats,
    required String sentiment,
    required String shortSummary,
    required String aiInsight,
    required Map<String, dynamic> correlations,
  }) async {
    await _supabase.from('me_monthly_analyses').insert({
      'user_id': _currentUserId,
      'year': year,
      'month': month,
      'stats': stats,
      'sentiment': sentiment,
      'short_summary': shortSummary,
      'ai_insight': aiInsight,
      'correlations': correlations,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return months[month - 1];
  }
}
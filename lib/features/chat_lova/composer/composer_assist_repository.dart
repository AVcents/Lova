// lib/features/chat_lova/composer/composer_assist_repository.dart

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'composer_assist_provider.dart';

abstract class ComposerAssistRepository {
  Future<List<String>> generate({
    required ComposerAssistParams params,
    required List<String> history,
    required String contextText,
  });
}

class MockComposerAssistRepository implements ComposerAssistRepository {
  final Random _random = Random();

  @override
  Future<List<String>> generate({
    required ComposerAssistParams params,
    required List<String> history,
    required String contextText,
  }) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(500)));

    final contextClues = _analyzeContext(history, contextText);
    final variations = <String>[];
    final baseMessages = _getBaseMessages(params, contextClues);

    for (int i = 0; i < 3; i++) {
      final variation = _buildVariation(params, baseMessages, contextClues, contextText, i);
      variations.add(variation);
    }

    return variations;
  }

  Map<String, dynamic> _analyzeContext(List<String> history, String contextText) {
    final allText = (history.join(' ') + ' ' + contextText).toLowerCase();

    final needsComfort = allText.contains(RegExp(r'\b(triste|difficile|dur|problème|inquiet|stress|anxieux|désolé|excuse|pardon)\b'));
    final isPositive = allText.contains(RegExp(r'\b(heureux|content|bien|super|génial|parfait|amour|merci)\b'));
    final hasQuestion = allText.contains('?');
    final isApology = allText.contains(RegExp(r'\b(excuse|pardon|désolé|regret|faute)\b'));
    final isProposal = allText.contains(RegExp(r'\b(propose|veux|aimerais|on pourrait|si on)\b'));

    String mood = 'neutral';
    if (isApology) mood = 'apologetic';
    else if (needsComfort) mood = 'supportive';
    else if (isPositive) mood = 'positive';
    else if (hasQuestion) mood = 'questioning';

    final keywords = <String>[];
    if (allText.contains('couple')) keywords.add('couple');
    if (allText.contains('communication')) keywords.add('communication');
    if (allText.contains('relation')) keywords.add('relation');
    if (allText.contains('temps')) keywords.add('temps');
    if (allText.contains('sortir')) keywords.add('sortir');

    return {
      'mood': mood,
      'keywords': keywords,
      'needsComfort': needsComfort,
      'isPositive': isPositive,
      'hasQuestion': hasQuestion,
      'isApology': isApology,
      'isProposal': isProposal,
    };
  }

  List<String> _getBaseMessages(ComposerAssistParams params, Map<String, dynamic> context) {
    final mood = context['mood'];

    final toneMessages = {
      0: { // Chaleureux
        'neutral': [
          "J'aimerais te parler de quelque chose qui me tient à cœur",
          "Je ressens le besoin de partager avec toi",
          "Il y a quelque chose d'important dont j'aimerais qu'on discute",
        ],
        'apologetic': [
          "Mon cœur, j'aimerais qu'on puisse se parler",
          "Je t'aime et j'aimerais qu'on échange sur ce qui s'est passé",
          "Tu comptes énormément pour moi, et j'ai besoin qu'on se parle",
        ],
        'positive': [
          "J'ai quelque chose de beau à partager avec toi",
          "Je pense à nous avec le sourire et j'aimerais te le dire",
          "Il y a quelque chose qui me remplit de joie et j'ai envie de t'en parler",
        ],
      },
      1: { // Neutre
        'neutral': [
          "Je voudrais aborder un sujet avec toi",
          "Il y a quelque chose dont nous devrions parler",
          "J'aimerais qu'on prenne le temps de discuter",
        ],
        'apologetic': [
          "Je pense qu'on devrait discuter de ce qui s'est passé",
          "Il me semble important qu'on fasse le point ensemble",
          "J'aimerais qu'on puisse échanger sur la situation",
        ],
        'positive': [
          "J'ai quelque chose à te dire",
          "Je voudrais partager quelque chose avec toi",
          "Il y a un sujet qui me tient à cœur",
        ],
      },
      2: { // Assertif
        'neutral': [
          "Nous devons parler de quelque chose d'important",
          "Il est temps qu'on aborde ce sujet",
          "Je pense qu'il faut qu'on mette les choses au clair",
        ],
        'apologetic': [
          "Il faut qu'on règle ce malentendu",
          "Nous devons absolument discuter de ce qui s'est passé",
          "Je veux qu'on tire les choses au clair",
        ],
        'positive': [
          "J'ai quelque chose d'important à te dire",
          "Il faut que je te parle de quelque chose",
          "J'ai une nouvelle qui va t'intéresser",
        ],
      },
    };

    final moodMessages = toneMessages[params.tone]?[mood] ?? toneMessages[params.tone]?['neutral'];
    return moodMessages ?? toneMessages[0]!['neutral']!;
  }

  String _buildVariation(ComposerAssistParams params, List<String> baseMessages,
      Map<String, dynamic> context, String contextText, int variationIndex) {
    final base = baseMessages[_random.nextInt(baseMessages.length)];
    String message = base;

    // Intégrer le contexte si fourni
    if (contextText.isNotEmpty) {
      message = _integrateContext(message, contextText, params);
    }

    // Adapter selon l'empathie
    if (params.empathy >= 2) {
      if (context['needsComfort'] == true || context['isApology'] == true) {
        message = _addEmpathyTouch(message);
      }
    }

    // Adapter selon la longueur
    switch (params.length) {
      case 0: // Court - garder tel quel
        break;
      case 1: // Moyen - ajouter une nuance
        message = _expandMessage(message, params, context, false);
        break;
      case 2: // Long - développer davantage
        message = _expandMessage(message, params, context, true);
        break;
    }

    // Variation pour différencier les 3 options
    message = _addVariationTouch(message, variationIndex, params, context);

    return message;
  }

  String _integrateContext(String message, String contextText, ComposerAssistParams params) {
    // Analyser le contexte pour l'intégrer naturellement
    final lowerContext = contextText.toLowerCase();

    if (lowerContext.contains(RegExp(r'\b(excuse|pardon|désolé)\b'))) {
      if (params.tone == 0) { // Chaleureux
        return "Mon amour, je sais que j'ai fait une erreur et $message pour qu'on puisse en parler.";
      } else if (params.tone == 2) { // Assertif
        return "Je reconnais mes torts et $message pour qu'on règle ça.";
      } else { // Neutre
        return "Je pense avoir fait une erreur et $message à ce sujet.";
      }
    }

    if (lowerContext.contains(RegExp(r'\b(propose|sortir|moment|activité)\b'))) {
      if (params.tone == 0) { // Chaleureux
        return "$message J'ai une idée qui pourrait nous faire plaisir à tous les deux.";
      } else if (params.tone == 2) { // Assertif
        return "$message J'ai une proposition concrète à te faire.";
      } else { // Neutre
        return "$message J'aimerais te proposer quelque chose.";
      }
    }

    // Intégration générale du contexte
    return "$message concernant ce dont j'aimerais te parler.";
  }

  String _addEmpathyTouch(String message) {
    final empathyPrefixes = [
      "Je sais que ce n'est pas toujours facile, mais ",
      "Avec tout l'amour que j'ai pour toi, ",
      "Tu comptes énormément pour moi, et ",
      "Je tiens à notre relation, c'est pourquoi ",
    ];

    final prefix = empathyPrefixes[_random.nextInt(empathyPrefixes.length)];
    return prefix + message.toLowerCase();
  }

  String _expandMessage(String message, ComposerAssistParams params,
      Map<String, dynamic> context, bool isLong) {
    final additions = <String>[];

    // Ajouts selon le contexte
    if (context['hasQuestion'] == true) {
      additions.add(isLong
          ? "car j'ai l'impression qu'il y a des choses importantes à éclaircir entre nous"
          : "car j'ai quelques questions");
    }

    if (context['isApology'] == true) {
      additions.add(isLong
          ? "Je sais que j'ai pu te blesser et j'aimerais qu'on trouve ensemble comment réparer les choses"
          : "surtout après ce qui s'est passé");
    }

    if (context['isProposal'] == true) {
      additions.add(isLong
          ? "J'ai réfléchi à quelque chose qui pourrait nous rapprocher et nous faire du bien"
          : "car j'ai une idée à te soumettre");
    }

    // Ajouts selon le ton
    if (params.tone == 0) { // Chaleureux
      additions.add(isLong
          ? "Notre relation me tient vraiment à cœur et je pense que la communication est essentielle pour nous"
          : "car notre complicité est précieuse");
    } else if (params.tone == 2) { // Assertif
      additions.add(isLong
          ? "Il me semble important qu'on soit sur la même longueur d'onde pour avancer sereinement"
          : "pour qu'on soit clairs tous les deux");
    }

    if (additions.isNotEmpty) {
      final addition = additions[_random.nextInt(additions.length)];
      return "$message $addition.";
    }

    return message;
  }

  String _addVariationTouch(String message, int index, ComposerAssistParams params, Map<String, dynamic> context) {
    switch (index) {
      case 0:
        return message; // Version de base
      case 1:
      // Ajouter une question
        if (context['isApology'] == true) {
          return "$message Tu serais d'accord pour qu'on en discute ?";
        } else if (params.tone == 0) {
          return "$message Qu'est-ce que tu en penses ?";
        } else {
          return "$message Es-tu disponible pour en discuter ?";
        }
      case 2:
      // Ajouter une proposition de moment
        if (context['isApology'] == true) {
          return "$message Je suis libre ce soir si tu veux.";
        } else {
          return "$message On pourrait en parler ce soir si tu veux.";
        }
      default:
        return message;
    }
  }
}

final composerAssistRepositoryProvider = Provider<ComposerAssistRepository>((ref) {
  return MockComposerAssistRepository();
});
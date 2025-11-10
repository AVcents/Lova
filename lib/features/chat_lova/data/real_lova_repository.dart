import 'dart:developer' as developer;

// TODO: Remplacer par MistralApiClient
import 'package:lova/core/api/openai_api_client.dart';
import 'package:lova/features/chat_lova/data/lova_repository.dart';
import 'package:lova/features/chat_lova/models/lova_message.dart';

class RealLovaRepository implements LovaRepository {
  // TODO: Remplacer par MistralApiClient une fois implémenté
  final OpenAIApiClient _client = OpenAIApiClient();
  // final MistralApiClient _client = MistralApiClient();

  @override
  Stream<LovaMessage> getResponse(
    String userInput,
    List<LovaMessage> history,
  ) async* {
    // TODO: Adapter ce code pour utiliser l'API Mistral au lieu d'OpenAI
    // Le streaming SSE devrait fonctionner de manière similaire
    // L'API Mistral utilise aussi le format SSE (Server-Sent Events)

    // Validation des entrées
    if (userInput.trim().isEmpty) {
      yield LovaMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content:
            'Je n\'ai pas reçu votre message. Pouvez-vous reformuler votre question ?',
        isFromUser: false,
        timestamp: DateTime.now(),
      );
      return;
    }

    // Construction des messages pour OpenAI
    final messages = _buildMessages(userInput, history);
    final buffer = StringBuffer();
    bool hasReceivedContent = false;

    try {
      developer.log('=== DÉBUT ENVOI MESSAGE ===', name: 'RealLovaRepository');

      // Votre OpenAIApiClient fait déjà le parsing SSE correctement !
      // On récupère directement les morceaux de texte
      await for (final textChunk in _client.sendMessage(messages)) {
        developer.log('Chunk reçu: "$textChunk"', name: 'RealLovaRepository');

        // Ignorer les chunks d'erreur
        if (textChunk.startsWith('[ERREUR]')) {
          developer.log(
            'Erreur détectée: $textChunk',
            name: 'RealLovaRepository',
          );
          throw Exception(textChunk.substring(8));
        }

        // Accumuler le contenu
        if (textChunk.isNotEmpty) {
          buffer.write(textChunk);
          hasReceivedContent = true;
          developer.log(
            'Buffer actuel: "${buffer.toString()}"',
            name: 'RealLovaRepository',
          );
        }
      }

      developer.log('=== FIN RÉCEPTION ===', name: 'RealLovaRepository');
      developer.log(
        'Buffer final: "${buffer.toString()}"',
        name: 'RealLovaRepository',
      );

      // Message final
      if (hasReceivedContent) {
        final finalContent = _cleanContent(buffer.toString());
        yield LovaMessage(
          id: DateTime.now()
              .add(const Duration(milliseconds: 1))
              .microsecondsSinceEpoch
              .toString(),
          content: finalContent,
          isFromUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        yield LovaMessage(
          id: DateTime.now()
              .add(const Duration(milliseconds: 2))
              .microsecondsSinceEpoch
              .toString(),
          content:
              'Je rencontre des difficultés à répondre. Pouvez-vous réessayer ?',
          isFromUser: false,
          timestamp: DateTime.now(),
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la génération de réponse',
        error: e,
        stackTrace: stackTrace,
        name: 'RealLovaRepository',
      );

      yield LovaMessage(
        id: DateTime.now()
            .add(const Duration(milliseconds: 3))
            .microsecondsSinceEpoch
            .toString(),
        content:
            'Je rencontre une difficulté technique. Pouvez-vous réessayer dans quelques instants ?',
        isFromUser: false,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Construit la liste des messages pour OpenAI
  List<Map<String, String>> _buildMessages(
    String userInput,
    List<LovaMessage> history,
  ) {
    final messages = <Map<String, String>>[
      {
        "role": "system",
        "content": """
Tu es LOVA 💝, une psychologue de couple chaleureuse et expérimentée. Tu parles de manière naturelle et directe, sans formules toutes faites.

🎯 TON STYLE DE COMMUNICATION :
- Parle comme une amie bienveillante et professionnelle
- Utilise des emojis avec parcimonie pour rendre la conversation chaleureuse
- Évite de commencer tes phrases par "Si", "Il faut que", "Vous devriez"  
- Privilégie des débuts de phrase variés et naturels
- Exprime-toi de façon affirmative et confiante

💬 EXEMPLES DE BONNES FORMULATIONS :
- "Ce que tu décris me fait penser à..."
- "Dans cette situation, je remarque que..."
- "Ton ressenti est complètement légitime..."
- "Une chose qui pourrait aider, c'est..."
- "J'ai l'impression que..."
- "Ce qui me frappe dans ton message..."

🧠 TON APPROCHE :
- Écoute active et validation des émotions
- Questions ouvertes pour encourager la réflexion  
- Conseils concrets basés sur la psychologie positive
- Communication bienveillante mais directe

✨ STRUCTURE DE TES RÉPONSES :
1. Accueille l'émotion avec empathie
2. Partage ton analyse professionnelle
3. Propose des pistes concrètes
4. Pose une question pour approfondir

💡 STYLE :
- Messages de 100-150 mots maximum
- Ton conversationnel et authentique
- Évite les "Si" répétitifs et les formules conditionnelles
- Sois directe tout en restant bienveillante

Tu es là pour accompagner avec authenticité, pas pour donner des leçons. 🤗
""",
      },
    ];

    // Ajouter l'historique (limité aux 10 derniers messages pour éviter la surcharge)
    final recentHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    for (final message in recentHistory) {
      messages.add({
        "role": message.isFromUser ? "user" : "assistant",
        "content": message.content.trim(),
      });
    }

    // Ajouter le message actuel de l'utilisateur
    messages.add({"role": "user", "content": userInput.trim()});

    return messages;
  }

  /// Nettoie et formate le contenu final pour une meilleure lisibilité
  String _cleanContent(String content) {
    if (content.isEmpty) return content;

    developer.log(
      'Contenu AVANT nettoyage: "$content"',
      name: 'RealLovaRepository',
    );

    // Étape 1: Nettoyer les caractères indésirables et normaliser
    String cleaned = content
        // Supprimer les caractères de contrôle invisibles
        .replaceAll(RegExp(r'[\u0000-\u001F\u007F-\u009F]'), '')
        // Normaliser les espaces et sauts de ligne
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n[ \t]*\n'), '\n\n')
        .trim();

    developer.log('Après étape 1: "$cleaned"', name: 'RealLovaRepository');

    // Étape 2: Ajouter des espaces manquants après la ponctuation (SANS TOUCHER AUX MOTS)
    cleaned = cleaned
        // Espace après point, virgule, etc. SEULEMENT si suivi d'une majuscule
        .replaceAllMapped(
          RegExp(r'([.!?,:;])([A-ZÀ-Ÿ])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        );

    developer.log('Après étape 2: "$cleaned"', name: 'RealLovaRepository');

    // Étape 3: Corrections spécifiques
    cleaned = cleaned
        // Corriger les espaces avant la ponctuation (FIX du bug $1)
        .replaceAllMapped(RegExp(r'\s+([.!?,:;])'), (match) => match.group(1)!)
        // Limiter les sauts de ligne multiples
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        // Supprimer les espaces en début/fin
        .trim();

    developer.log('Après étape 3: "$cleaned"', name: 'RealLovaRepository');

    // Étape 4: S'assurer que chaque phrase commence par une majuscule
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'([.!?]\s+)([a-zà-ÿ])'),
      (match) => '${match.group(1)}${match.group(2)!.toUpperCase()}',
    );

    // Étape 5: Première lettre en majuscule si nécessaire
    if (cleaned.isNotEmpty && cleaned[0].toLowerCase() == cleaned[0]) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    developer.log('Contenu FINAL: "$cleaned"', name: 'RealLovaRepository');

    return cleaned;
  }
}

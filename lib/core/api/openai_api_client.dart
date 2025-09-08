import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIApiClient {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  final Uri _uri = Uri.parse('https://api.openai.com/v1/chat/completions');

  Stream<String> sendMessage(List<Map<String, String>> messages) async* {
    final request = http.Request('POST', _uri);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    });

    request.body = jsonEncode({
      'model': 'gpt-4o',
      'stream': true,
      'messages': messages,
      'temperature': 0.7,
    });

    try {
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }

      final utf8Stream = response.stream.transform(utf8.decoder);
      await for (final line in utf8Stream) {
        for (final chunk in line.trim().split('\n')) {
          if (chunk.startsWith('data:')) {
            final content = chunk.substring(5).trim();
            if (content == '[DONE]') break;

            final Map<String, dynamic> decoded = jsonDecode(content);
            final delta = decoded['choices']?[0]?['delta'];
            final text = delta?['content'];
            if (text != null) yield text;
          }
        }
      }
    } catch (e) {
      yield '[ERREUR] ${e.toString()}';
    }
  }
}

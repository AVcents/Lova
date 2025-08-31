// lib/features/chat_lova/data/mock_lova_repository.dart

import 'dart:async';
import 'package:lova/features/chat_lova/models/lova_message.dart';
import 'package:lova/features/chat_lova/data/lova_repository.dart';

class MockLovaRepository implements LovaRepository {
  @override
  Stream<LovaMessage> getResponse(String userMessage, List<LovaMessage> history) async* {
    yield LovaMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: 'Je réfléchis à ta demande...',
      isFromUser: false,
      timestamp: DateTime.now(),
    );

    await Future.delayed(const Duration(seconds: 1));

    yield LovaMessage(
      id: DateTime.now().add(const Duration(milliseconds: 1)).microsecondsSinceEpoch.toString(),
      content: _generateResponse(userMessage),
      isFromUser: false,
      timestamp: DateTime.now(),
    );
  }

  String _generateResponse(String input) {
    // Simulation simple, on pourra complexifier
    if (input.toLowerCase().contains('bonjour')) {
      return "Bonjour à toi aussi 💬 ! Que puis-je faire pour toi aujourd’hui ?";
    } else if (input.toLowerCase().contains('aide')) {
      return "Je suis là pour t’écouter et t’accompagner. Dis-m’en un peu plus.";
    } else {
      return "Merci pour ton message. Tu veux en parler un peu plus ?";
    }
  }
}
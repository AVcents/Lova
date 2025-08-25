import 'package:lova/features/chat_lova/models/lova_message.dart';

abstract class LovaRepository {
  Stream<LovaMessage> getResponse(String userInput, List<LovaMessage> history);
}
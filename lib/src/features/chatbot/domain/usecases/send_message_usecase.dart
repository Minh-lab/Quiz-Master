import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(SendMessageParams params) {
    return repository.sendMessage(
      uid: params.uid,
      sessionId: params.sessionId,
      message: params.message,
      history: params.history,
    );
  }
}

class SendMessageParams {
  final String uid;
  final String sessionId;
  final String message;
  final List<ChatMessageEntity> history;

  SendMessageParams({
    required this.uid,
    required this.sessionId,
    required this.message,
    required this.history,
  });
}

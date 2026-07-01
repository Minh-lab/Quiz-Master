import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class GetChatHistoryUseCase {
  final ChatbotRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageEntity>> call(GetChatHistoryParams params) {
    return repository.getChatHistory(params.uid, params.sessionId);
  }
}

class GetChatHistoryParams {
  final String uid;
  final String sessionId;

  GetChatHistoryParams({required this.uid, required this.sessionId});
}

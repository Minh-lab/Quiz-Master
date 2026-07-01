import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class DeleteChatSessionUseCase {
  final ChatbotRepository repository;

  DeleteChatSessionUseCase(this.repository);

  Future<void> call(String uid, String sessionId) {
    return repository.deleteChatSession(uid, sessionId);
  }
}

import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_session_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class GetSessionsUseCase {
  final ChatbotRepository repository;

  GetSessionsUseCase(this.repository);

  Future<List<ChatSessionEntity>> call(String uid) {
    return repository.getChatSessions(uid);
  }
}

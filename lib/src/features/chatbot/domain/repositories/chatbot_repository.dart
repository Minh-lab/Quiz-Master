import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_session_entity.dart';

abstract class ChatbotRepository {
  Future<List<ChatSessionEntity>> getChatSessions(String uid);
  
  Future<String> createChatSession(String uid, String title);
  
  Future<List<ChatMessageEntity>> getChatHistory(String uid, String sessionId);
  
  Future<ChatMessageEntity> sendMessage({
    required String uid,
    required String sessionId,
    required String message,
    required List<ChatMessageEntity> history,
  });

  Future<void> deleteChatSession(String uid, String sessionId);
}

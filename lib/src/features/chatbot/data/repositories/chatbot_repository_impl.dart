import 'package:quiz_mater_apllication/src/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_session_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatSessionEntity>> getChatSessions(String uid) async {
    return await remoteDataSource.getChatSessions(uid);
  }

  @override
  Future<String> createChatSession(String uid, String title) async {
    return await remoteDataSource.createChatSession(uid, title);
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory(String uid, String sessionId) async {
    return await remoteDataSource.getChatHistory(uid, sessionId);
  }

  @override
  Future<ChatMessageEntity> sendMessage({
    required String uid,
    required String sessionId,
    required String message,
    required List<ChatMessageEntity> history,
  }) async {
    // Lưu tin nhắn của người dùng trước
    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      role: MessageRole.user,
      createdAt: DateTime.now(),
      status: MessageStatus.success,
    );
    await remoteDataSource.saveMessage(uid, sessionId, userMessage);

    final aiResponseText = await remoteDataSource.sendMessage(sessionId, uid, message, history);
    
    // Lưu tin nhắn trả về từ AI
    final aiMessage = ChatMessageEntity(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: aiResponseText,
      role: MessageRole.model,
      createdAt: DateTime.now(),
      status: MessageStatus.success,
    );
    
    await remoteDataSource.saveMessage(uid, sessionId, aiMessage);

    return aiMessage;
  }

  @override
  Future<void> deleteChatSession(String uid, String sessionId) async {
    await remoteDataSource.deleteChatSession(uid, sessionId);
  }
}

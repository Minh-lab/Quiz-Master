import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/data/models/chat_message_model.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/data/models/chat_session_model.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';

abstract class ChatbotRemoteDataSource {
  Future<List<ChatSessionModel>> getChatSessions(String uid);
  Future<String> createChatSession(String uid, String title);
  Future<List<ChatMessageModel>> getChatHistory(String uid, String sessionId);
  Future<String> sendMessage(String sessionId, String uid, String message, List<ChatMessageEntity> history);
  Future<void> saveMessage(String uid, String sessionId, ChatMessageEntity message);
  Future<void> deleteChatSession(String uid, String sessionId);
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final FirebaseFirestore firestore;
  late final GenerativeModel _model;

  static const String _systemInstruction = '''
Bạn là một gia sư AI của ứng dụng Quiz Master.
Nhiệm vụ của bạn là hỗ trợ học sinh ôn thi THPT Quốc Gia.

Quy tắc trả lời:
* Luôn trả lời bằng tiếng Việt.
* Trả lời ngắn gọn, rõ ràng, đúng trọng tâm.
* Khi giải câu hỏi trắc nghiệm, hãy nêu đáp án đúng trước.
* Giải thích vì sao đáp án đúng.
* Nếu có dữ liệu đáp án học sinh chọn, hãy chỉ ra vì sao đáp án đó sai.
* Nếu thiếu dữ kiện, hãy nói rõ là chưa đủ dữ liệu, không được đoán bừa.
* Không khuyến khích học tủ, gian lận hoặc đưa đáp án thiếu căn cứ.
''';

  ChatbotRemoteDataSourceImpl({required this.firestore}) {
    _model = FirebaseAI.vertexAI(location: 'global').generativeModel(
      model: 'gemini-3.5-flash',
      systemInstruction: Content.system(_systemInstruction),
    );
  }

  @override
  Future<List<ChatSessionModel>> getChatSessions(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ChatSessionModel.fromFirestore(doc)).toList();
  }

  @override
  Future<String> createChatSession(String uid, String title) async {
    final docRef = await firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageRole': '',
    });
    return docRef.id;
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory(String uid, String sessionId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs.map((doc) => ChatMessageModel.fromFirestore(doc)).toList();
  }

  @override
  Future<String> sendMessage(String sessionId, String uid, String message, List<ChatMessageEntity> history) async {
    try {
      final recentHistory = history.length > 20
          ? history.sublist(history.length - 20)
          : history;

      final chatHistory = recentHistory.map((msg) {
        final role = msg.role == MessageRole.user ? 'user' : 'model';
        return Content(role, [TextPart(msg.content)]);
      }).toList();

      final chat = _model.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.text(message));
      
      return response.text ?? 'Xin lỗi, tôi chưa thể trả lời câu hỏi này.';
    } catch (e) {
      throw Exception('Lỗi khi gọi AI Gemini: \$e');
    }
  }

  @override
  Future<void> saveMessage(String uid, String sessionId, ChatMessageEntity message) async {
    final model = ChatMessageModel(
      id: message.id,
      content: message.content,
      role: message.role,
      createdAt: message.createdAt,
    );
    
    final batch = firestore.batch();
    
    final messageRef = firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .doc(sessionId)
        .collection('messages')
        .doc(message.id);
        
    batch.set(messageRef, model.toFirestore());
    
    final sessionRef = firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .doc(sessionId);
        
    batch.set(
      sessionRef, 
      {
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessage': message.content,
        'lastMessageRole': message.role.name,
      },
      SetOptions(merge: true),
    );
    
    await batch.commit();
  }
  @override
  Future<void> deleteChatSession(String uid, String sessionId) async {
    // Để xóa hoàn toàn 1 session, chúng ta xóa document session.
    // (Các messages subcollection có thể trở thành orphaned document, nhưng sẽ không hiện ra nữa).
    await firestore
        .collection('users')
        .doc(uid)
        .collection('chat_sessions')
        .doc(sessionId)
        .delete();
  }
}

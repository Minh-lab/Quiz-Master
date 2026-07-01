import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.role,
    required super.createdAt,
    super.status,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      content: data['content'] ?? '',
      role: data['role'] == 'user' ? MessageRole.user : MessageRole.model,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: MessageStatus.success,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'role': role == MessageRole.user ? 'user' : 'model',
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_session_entity.dart';

class ChatSessionModel extends ChatSessionEntity {
  const ChatSessionModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    super.lastMessage,
    super.lastMessageRole,
  });

  factory ChatSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatSessionModel(
      id: doc.id,
      title: data['title'] ?? 'Đoạn chat mới',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] as String?,
      lastMessageRole: data['lastMessageRole'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageRole != null) 'lastMessageRole': lastMessageRole,
    };
  }
}

import 'package:equatable/equatable.dart';

class ChatSessionEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  final String? lastMessageRole;

  const ChatSessionEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.lastMessageRole,
  });

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt, lastMessage, lastMessageRole];
}

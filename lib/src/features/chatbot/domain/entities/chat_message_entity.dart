import 'package:equatable/equatable.dart';

enum MessageRole { user, model }
enum MessageStatus { sending, success, error }

class ChatMessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime createdAt;
  final MessageStatus status;
  final String? errorMessage;

  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
    this.status = MessageStatus.success,
    this.errorMessage,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? createdAt,
    MessageStatus? status,
    String? errorMessage,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, content, role, createdAt, status, errorMessage];
}

import 'package:equatable/equatable.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();
  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageEntity> messages;
  final bool isSending;
  final String? sessionId;

  const ChatbotLoaded({
    required this.messages,
    this.isSending = false,
    this.sessionId,
  });

  ChatbotLoaded copyWith({
    List<ChatMessageEntity>? messages,
    bool? isSending,
    String? sessionId,
  }) {
    return ChatbotLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, sessionId];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}

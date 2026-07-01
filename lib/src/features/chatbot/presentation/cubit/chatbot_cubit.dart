import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/create_chat_session_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/send_message_usecase.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final CreateChatSessionUseCase createChatSessionUseCase;
  final SendMessageUseCase sendMessageUseCase;
  
  String? _currentSessionId;
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_uid';
  
  ChatbotCubit({
    required this.getChatHistoryUseCase,
    required this.createChatSessionUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatbotInitial());

  Future<void> initSession(String? sessionId) async {
    _currentSessionId = sessionId;
    if (sessionId == null) {
      emit(const ChatbotLoaded(messages: [], isSending: false));
    } else {
      await loadMessages(sessionId);
    }
  }

  Future<void> loadMessages(String sessionId) async {
    emit(ChatbotLoading());
    try {
      final messages = await getChatHistoryUseCase(
        GetChatHistoryParams(uid: uid, sessionId: sessionId),
      );
      emit(ChatbotLoaded(messages: messages, sessionId: sessionId));
    } catch (e) {
      emit(ChatbotError("Không thể tải tin nhắn: \$e"));
    }
  }

  Future<void> sendMessage(String content) async {
    final currentState = state;
    if (currentState is! ChatbotLoaded) return;

    try {
      // 1. Tạo session nếu chưa có
      if (_currentSessionId == null) {
        final title = content.length > 30 ? "\${content.substring(0, 30)}..." : content;
        _currentSessionId = await createChatSessionUseCase(
          CreateChatSessionParams(uid: uid, title: title),
        );
      }

      // 2. Thêm tin nhắn user vào local state
      final userMsg = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        role: MessageRole.user,
        createdAt: DateTime.now(),
        status: MessageStatus.sending,
      );

      final updatedMessages = List<ChatMessageEntity>.from(currentState.messages)..add(userMsg);
      
      emit(currentState.copyWith(
        messages: updatedMessages,
        isSending: true,
        sessionId: _currentSessionId,
      ));

      // 3. Gọi AI
      final aiMessage = await sendMessageUseCase(
        SendMessageParams(
          uid: uid,
          sessionId: _currentSessionId!,
          message: content,
          history: currentState.messages, // Gửi history trước khi add userMsg
        ),
      );

      // 4. Update UI: userMsg success + add aiMessage
      final finalMessages = updatedMessages.map((m) {
        if (m.id == userMsg.id) {
          return m.copyWith(status: MessageStatus.success);
        }
        return m;
      }).toList()..add(aiMessage);

      emit(currentState.copyWith(
        messages: finalMessages,
        isSending: false,
      ));

    } catch (e) {
      // Dừng vòng quay loading nếu có lỗi
      emit(currentState.copyWith(isSending: false));
    }
  }
}

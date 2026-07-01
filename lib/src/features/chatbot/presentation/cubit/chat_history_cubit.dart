import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/get_sessions_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/delete_chat_session_usecase.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final GetSessionsUseCase getSessionsUseCase;
  final DeleteChatSessionUseCase deleteChatSessionUseCase;

  ChatHistoryCubit({
    required this.getSessionsUseCase,
    required this.deleteChatSessionUseCase,
  }) : super(ChatHistoryInitial());

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_uid';

  Future<void> loadSessions() async {
    emit(ChatHistoryLoading());
    try {
      final sessions = await getSessionsUseCase(uid);
      emit(ChatHistoryLoaded(sessions));
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await deleteChatSessionUseCase(uid, sessionId);
      // Sau khi xóa thành công thì tải lại danh sách
      await loadSessions();
    } catch (e) {
      // Có thể emit Error nếu cần
    }
  }
}

import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';

class CreateChatSessionUseCase {
  final ChatbotRepository repository;

  CreateChatSessionUseCase(this.repository);

  Future<String> call(CreateChatSessionParams params) {
    return repository.createChatSession(params.uid, params.title);
  }
}

class CreateChatSessionParams {
  final String uid;
  final String title;

  CreateChatSessionParams({required this.uid, required this.title});
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chatbot_state.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/widgets/chat_bubble.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/widgets/chat_input.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/widgets/typing_indicator.dart';

class ChatbotScreen extends StatefulWidget {
  final String? sessionId;

  const ChatbotScreen({super.key, this.sessionId});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatbotCubit>().initSession(widget.sessionId);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với AI'),
      ),
      body: BlocConsumer<ChatbotCubit, ChatbotState>(
        listener: (context, state) {
          if (state is ChatbotLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        builder: (context, state) {
          if (state is ChatbotLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatbotLoaded) {
            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: Text(
                            'Hãy đặt câu hỏi đầu tiên!',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: state.messages.length + (state.isSending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return const TypingIndicator();
                            }
                            return ChatBubble(message: state.messages[index]);
                          },
                        ),
                ),
                ChatInput(
                  isSending: state.isSending,
                  onSend: (text) {
                    context.read<ChatbotCubit>().sendMessage(text);
                  },
                ),
              ],
            );
          }
          return const Center(child: Text('Lỗi tải dữ liệu chat'));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:quiz_mater_apllication/src/core/widgets/math_text_builder.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MathTextBuilder(
              text: message.content,
              maxWidth: MediaQuery.of(context).size.width * 0.85 - 24, // trừ đi padding 12x2
              style: TextStyle(
                color: isUser ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

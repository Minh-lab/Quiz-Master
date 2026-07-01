import 'package:flutter/material.dart';

class ChatbotTempScreen extends StatelessWidget {
  const ChatbotTempScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      body: const Center(
        child: Text(
          'Màn hình Chatbot đang phát triển...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chat_history_cubit.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chat_history_state.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatHistoryCubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử Chat AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tạo đoạn chat mới',
            onPressed: () async {
              // Mở màn hình chatbot trắng (không truyền sessionId)
              await context.push(AppRouter.chatbotDetail); 
              if (context.mounted) {
                context.read<ChatHistoryCubit>().loadSessions();
              }
            },
          )
        ],
      ),
      body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
        builder: (context, state) {
          if (state is ChatHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatHistoryLoaded) {
            if (state.sessions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có phiên trò chuyện nào.\nHãy nhấn nút + để bắt đầu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.chat),
                  ),
                  title: Text(session.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Cập nhật: ${session.updatedAt.toString().split('.')[0]}'),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (value) {
                      if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text('Bạn có chắc muốn xóa đoạn chat này không?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Hủy'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.read<ChatHistoryCubit>().deleteSession(session.id);
                                },
                                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Xóa đoạn chat', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Navigate to detail with Session ID
                    await context.push('${AppRouter.chatbotDetail}?sessionId=${session.id}');
                    if (context.mounted) {
                      context.read<ChatHistoryCubit>().loadSessions();
                    }
                  },
                );
              },
            );
          } else if (state is ChatHistoryError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRouter.chatbotDetail);
          if (context.mounted) {
            context.read<ChatHistoryCubit>().loadSessions();
          }
        },
        icon: const Icon(Icons.smart_toy),
        label: const Text('Hỏi AI ngay'),
      ),
    );
  }
}

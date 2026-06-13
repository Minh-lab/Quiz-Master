import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

class WrongAnswersScreen extends StatelessWidget {
  const WrongAnswersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: 'Sổ lỗi sai'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
              ),
              title: Text('Câu hỏi ${index + 1} - Đề Toán học', style: AppTypography.bodyLarge()),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Bạn đã chọn A, đáp án đúng là C.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

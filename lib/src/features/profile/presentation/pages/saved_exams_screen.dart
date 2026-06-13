import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

class SavedExamsScreen extends StatelessWidget {
  const SavedExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: 'Đề đã lưu'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text('Đề thi Vật Lý số ${index + 1}', style: AppTypography.bodyLarge()),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('60 phút', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(width: 16),
                    Icon(Icons.question_answer_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('50 câu', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {},
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

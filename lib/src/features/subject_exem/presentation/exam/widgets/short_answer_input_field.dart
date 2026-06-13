import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';

class ShortAnswerInputField extends StatefulWidget {
  final QuestionEntity question;
  final String initialValue;
  final Function(String) onChanged;

  const ShortAnswerInputField({
    super.key,
    required this.question,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<ShortAnswerInputField> createState() => _ShortAnswerInputFieldState();
}

class _ShortAnswerInputFieldState extends State<ShortAnswerInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant ShortAnswerInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cực kỳ quan trọng: Nếu học sinh đổi sang câu hỏi điền số khác,
    // ta phải cập nhật lại chữ hiển thị trong ô nhập liệu theo dữ liệu mới
    if (oldWidget.question.id != widget.question.id) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhập đáp án số của bạn dưới đây:',
          style: AppTypography.headlineSmall().copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          decoration: InputDecoration(
            hintText: 'Nhập câu trả lời (Ví dụ: 19.2, -5, 26...)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceVariant, width:3),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppTypography.headlineMedium().copyWith(
            fontWeight: FontWeight.bold,
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

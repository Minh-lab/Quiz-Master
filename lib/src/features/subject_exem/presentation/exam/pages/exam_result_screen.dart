import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/timer_cubit/timer_cubit.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/firebase_image.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/core/widgets/math_text_builder.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/exam_detail_screen.dart';

class ExamResultScreen extends StatefulWidget {
  final List<QuestionEntity> questions;
  final Map<int, dynamic> userAnswers;
  final int timeTakenInSeconds;
  final String subjectId;
  final String examId;
  final String title;
  final int duration;

  const ExamResultScreen({
    Key? key,
    required this.questions,
    required this.userAnswers,
    required this.timeTakenInSeconds,
    required this.subjectId,
    required this.examId,
    required this.title,
    required this.duration,
  }) : super(key: key);

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  int correctCount = 0;
  int wrongCount = 0;
  int skippedCount = 0;
  double earnedScore = 0.0;
  double totalScore = 0.0;

  String _filter = 'Tất cả câu';
  final List<String> _filters = ['Tất cả câu', 'Câu đúng', 'Câu sai', 'Bỏ qua'];

  List<QuestionEntity> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _calculateResult();
    _filteredQuestions = widget.questions;
  }

  void _calculateResult() {
    for (var q in widget.questions) {
      totalScore += q.score;
      var userAnswer = widget.userAnswers[q.order];

      if (userAnswer == null || userAnswer == '') {
        skippedCount++;
      } else {
        bool isCorrect = _checkCorrect(q, userAnswer);
        if (isCorrect) {
          correctCount++;
          earnedScore += q.score;
        } else {
          wrongCount++;
        }
      }
    }
  }

  bool _checkCorrect(QuestionEntity q, dynamic userAnswer) {
    if (q.type == 'true_false') {
      try {
        Map<String, dynamic> correctMap = Map<String, dynamic>.from(
          q.correctAnswer as Map,
        );
        Map<String, dynamic> userMap = Map<String, dynamic>.from(
          userAnswer as Map,
        );
        bool correct = true;
        for (var k in correctMap.keys) {
          if (userMap[k] != correctMap[k]) {
            correct = false;
            break;
          }
        }
        return correct;
      } catch (_) {
        return false;
      }
    } else {
      return userAnswer.toString().trim().toLowerCase() ==
          q.correctAnswer.toString().trim().toLowerCase();
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _filter = filter;
      if (filter == 'Tất cả câu') {
        _filteredQuestions = widget.questions;
      } else if (filter == 'Câu đúng') {
        _filteredQuestions = widget.questions.where((q) {
          var ans = widget.userAnswers[q.order];
          if (ans == null || ans == '') return false;
          return _checkCorrect(q, ans);
        }).toList();
      } else if (filter == 'Câu sai') {
        _filteredQuestions = widget.questions.where((q) {
          var ans = widget.userAnswers[q.order];
          if (ans == null || ans == '') return false;
          return !_checkCorrect(q, ans);
        }).toList();
      } else if (filter == 'Bỏ qua') {
        _filteredQuestions = widget.questions.where((q) {
          var ans = widget.userAnswers[q.order];
          return ans == null || ans == '';
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppAppbar(
            title: 'Kết quả thi',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildResultSummaryCard()),
            SliverToBoxAdapter(child: _buildFilterBar()),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildQuestionReviewCard(_filteredQuestions[index]);
              }, childCount: _filteredQuestions.length),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24), // Spacing at bottom
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildResultSummaryCard() {
    double accuracy = widget.questions.isEmpty
        ? 0
        : (correctCount / widget.questions.length) * 100;
    int minutes = widget.timeTakenInSeconds ~/ 60;
    int seconds = widget.timeTakenInSeconds % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Nền xanh ngọc bích nhạt
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCFCE7), width: 2),
      ),
      child: Column(
        children: [
          // Icon cúp vàng
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 80),
          const SizedBox(height: 12),
          Text(
            'Hoàn thành!',
            style: AppTypography.headlineLarge().copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chúc mừng bạn đã hoàn thành bài thi.',
            style: AppTypography.bodyMedium().copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Khối điểm số
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Điểm số', style: AppTypography.labelMedium()),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          earnedScore.toStringAsFixed(1),
                          style: AppTypography.headlineLarge().copyWith(
                            color: AppColors.success,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / ${totalScore.toStringAsFixed(1)}',
                          style: AppTypography.headlineMedium().copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Thống kê Đúng/Sai/Tỷ lệ
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle_rounded,
                  iconColor: AppColors.success,
                  label: 'Đúng',
                  value: '$correctCount / ${widget.questions.length}',
                  valueColor: AppColors.success,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.cancel_rounded,
                  iconColor: AppColors.error,
                  label: 'Sai',
                  value: '$wrongCount / ${widget.questions.length}',
                  valueColor: AppColors.error,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.pie_chart_rounded,
                  iconColor: AppColors.primary,
                  label: 'Tỷ lệ',
                  value: '${accuracy.toStringAsFixed(0)}%',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Thời gian hoàn thành
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Thời gian: $minutes phút $seconds giây',
                style: AppTypography.bodyMedium().copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.labelMedium()),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.headlineSmall().copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Xem lại đáp án',
            style: AppTypography.headlineMedium().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filter,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
                items: _filters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_alt_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(value, style: AppTypography.bodyMedium()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    _applyFilter(newValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionReviewCard(QuestionEntity question) {
    var userAnswer = widget.userAnswers[question.order];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Câu số & Điểm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu ${question.order}',
                style: AppTypography.headlineSmall().copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${question.score} điểm',
                  style: AppTypography.labelSmall().copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nội dung câu hỏi
          MathTextBuilder(
            text: question.content,
            style: AppTypography.bodyLarge(),
          ),

          // Hình ảnh
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FirebaseImage(imageUrl: question.imageUrl!),
            ),

          const SizedBox(height: 16),

          if (userAnswer == null || userAnswer == '')
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warningBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bạn chưa chọn đáp án',
                    style: AppTypography.labelMedium().copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

          // Danh sách đáp án
          _buildReviewOptions(question, userAnswer),
        ],
      ),
    );
  }

  Widget _buildReviewOptions(QuestionEntity question, dynamic userAnswer) {
    if (question.type == 'multiple_choice') {
      List<String> labels = ['A', 'B', 'C', 'D'];
      return Column(
        children: List.generate(question.options.length, (index) {
          String label = labels[index];
          String optionText = question.options[index];

          bool isSelected = userAnswer?.toString().trim() == label;
          bool isCorrectAnswer =
              question.correctAnswer?.toString().trim() == label;

          return _buildMultipleChoiceOption(
            label: label,
            text: optionText,
            isSelected: isSelected,
            isCorrectAnswer: isCorrectAnswer,
          );
        }),
      );
    } else if (question.type == 'true_false') {
      Map<String, dynamic> correctMap = Map<String, dynamic>.from(
        question.correctAnswer as Map? ?? {},
      );
      Map<String, dynamic> userMap = Map<String, dynamic>.from(
        userAnswer as Map? ?? {},
      );
      List<String> keys = ['a', 'b', 'c', 'd'];

      return Column(
        children: List.generate(keys.length, (index) {
          String key = keys[index];
          if (index >= question.options.length) return const SizedBox();
          String optionText = question.options[index];

          bool userChoice = userMap[key] == true;
          bool correctChoice = correctMap[key] == true;

          bool isSelected = userMap.containsKey(key);
          bool isCorrect = userChoice == correctChoice;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: !isSelected
                  ? AppColors.surfaceVariant
                  : (isCorrect
                        ? AppColors.success.withValues(alpha: 0.05)
                        : AppColors.errorBackground),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !isSelected
                    ? AppColors.border
                    : (isCorrect
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.error),
                width: (!isCorrect && isSelected) ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(optionText, style: AppTypography.bodyMedium()),
                ),
                if (isSelected)
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppColors.success : AppColors.error,
                  ),
                if (!isSelected)
                  Text(
                    'Bỏ qua',
                    style: AppTypography.labelSmall().copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    } else if (question.type == 'short_answer') {
      bool isCorrect =
          userAnswer?.toString().trim().toLowerCase() ==
          question.correctAnswer?.toString().trim().toLowerCase();
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (userAnswer == null || userAnswer == '')
              ? AppColors.surfaceVariant
              : (isCorrect
                    ? AppColors.success.withValues(alpha: 0.05)
                    : AppColors.errorBackground),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (userAnswer == null || userAnswer == '')
                ? AppColors.border
                : (isCorrect
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.error),
            width: (!isCorrect && userAnswer != null && userAnswer != '')
                ? 2.0
                : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu trả lời của bạn: ${userAnswer ?? "Trống"}',
              style: AppTypography.bodyMedium(),
            ),
            const SizedBox(height: 8),
            Text(
              'Đáp án đúng: ${question.correctAnswer}',
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildMultipleChoiceOption({
    required String label,
    required String text,
    required bool isSelected,
    required bool isCorrectAnswer,
  }) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Color circleBg = AppColors.surfaceVariant;
    Color circleText = AppColors.textPrimary;
    IconData? suffixIcon;
    Color? suffixColor;

    if (isCorrectAnswer) {
      // Đáp án đúng luôn được đánh dấu xanh (nhạt hơn)
      bgColor = AppColors.success.withValues(alpha: 0.05);
      borderColor = AppColors.success.withValues(alpha: 0.5);
      circleBg = AppColors.success.withValues(alpha: 0.1);
      circleText = AppColors.success;
      suffixIcon = Icons.check_circle_rounded;
      suffixColor = AppColors.success;
    } else if (isSelected && !isCorrectAnswer) {
      // Đáp án người dùng chọn bị sai -> Nổi bật hơn với viền đậm
      bgColor = AppColors.errorBackground;
      borderColor = AppColors.error;
      circleBg = AppColors.error;
      circleText = Colors.white;
      suffixIcon = Icons.close_rounded;
      suffixColor = AppColors.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: (isSelected && !isCorrectAnswer) ? 2.0 : 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: circleBg,
            child: Text(
              label,
              style: TextStyle(color: circleText, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyLarge().copyWith(color: textColor),
            ),
          ),
          if (suffixIcon != null) Icon(suffixIcon, color: suffixColor),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => sl<ExamDetailBloc>()
                              ..add(FetchExamDetailEvent(examId: widget.examId, subjectId: widget.subjectId)),
                          ),
                          BlocProvider(
                            create: (context) => TimerCubit(),
                          ),
                        ],
                        child: ExamDetailScreen(
                          subjectId: widget.subjectId,
                          examId: widget.examId,
                          title: widget.title,
                          duration: widget.duration,
                        ),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Luyện lại bài',
                  style: AppTypography.labelLarge().copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.home_rounded, color: Colors.white),
                label: Text(
                  'Luyện đề khác',
                  style: AppTypography.labelLarge().copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

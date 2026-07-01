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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/save_exam_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/question.dart';

class ExamResultScreen extends StatefulWidget {
  final List<QuestionEntity> questions;
  final Map<int, dynamic> userAnswers;
  final int timeTakenInSeconds;
  final String subjectId;
  final String examId;
  final String title;
  final int duration;
  final bool isViewingHistory;

  const ExamResultScreen({
    Key? key,
    required this.questions,
    required this.userAnswers,
    required this.timeTakenInSeconds,
    required this.subjectId,
    required this.examId,
    required this.title,
    required this.duration,
    this.isViewingHistory = false,
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
    if (!widget.isViewingHistory) {
      _saveHistory();
    }
    _filteredQuestions = widget.questions;
  }

  Future<void> _saveHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final history = ExamHistoryEntity(
      id: '', 
      uid: uid,
      examId: widget.examId,
      examTitle: widget.title,
      subjectId: widget.subjectId,
      subjectName: widget
          .subjectId, 
      score: earnedScore,
      totalQuestions: widget.questions.length,
      correctAnswers: correctCount,
      wrongAnswers: wrongCount,
      skippedAnswers: skippedCount,
      accuracy: widget.questions.isEmpty
          ? 0
          : (correctCount / widget.questions.length) * 100,
      duration: widget.duration * 60,
      timeSpent: widget.timeTakenInSeconds,
      submittedAt: DateTime.now(),
      userAnswers: widget.userAnswers.map((key, value) => MapEntry(key.toString(), value)),
      questionsData: widget.questions.map((q) => QuestionModel.fromEntity(q).toJson()).toList(),
    );

    await sl<SaveExamHistoryUseCase>().call(history);
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
        backgroundColor: Theme.of(context).colorScheme.surface,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final successBg = isDark
        ? AppColors.darkSuccessBackground
        : AppColors.successBackground;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final primaryColor = Theme.of(context).colorScheme.primary;

    double accuracy = widget.questions.isEmpty
        ? 0
        : (correctCount / widget.questions.length) * 100;
    int minutes = widget.timeTakenInSeconds ~/ 60;
    int seconds = widget.timeTakenInSeconds % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: successBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: successColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 80),
          const SizedBox(height: 12),
          Text(
            'Hoàn thành!',
            style: AppTypography.headlineMedium().copyWith(
              color: successColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chúc mừng bạn đã hoàn thành bài thi.',
            style: AppTypography.bodyMedium().copyWith(color: textSecondary),
          ),
          const SizedBox(height: 24),

          // Khối điểm số
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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
                    Text(
                      'Điểm số',
                      style: AppTypography.labelMedium().copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          earnedScore.toStringAsFixed(1),
                          style: AppTypography.headlineMedium().copyWith(
                            color: successColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / ${totalScore.toStringAsFixed(1)}',
                          style: AppTypography.headlineMedium().copyWith(
                            color: textSecondary,
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
                  iconColor: successColor,
                  label: 'Đúng',
                  value: '$correctCount / ${widget.questions.length}',
                  valueColor: successColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.cancel_rounded,
                  iconColor: errorColor,
                  label: 'Sai',
                  value: '$wrongCount / ${widget.questions.length}',
                  valueColor: errorColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.pie_chart_rounded,
                  iconColor: primaryColor,
                  label: 'Tỷ lệ',
                  value: '${accuracy.toStringAsFixed(0)}%',
                  valueColor: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),

          // Thời gian hoàn thành
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule_rounded, color: textSecondary, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Thời gian: $minutes phút $seconds giây',
                  style: AppTypography.bodyMedium().copyWith(
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
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
          Expanded(
            child: Text(
              'Xem lại đáp án',
              style: AppTypography.headlineSmall().copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filter,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                items: _filters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          value,
                          style: AppTypography.bodyMedium().copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final warningBg = isDark
        ? AppColors.darkWarningBackground
        : AppColors.warningBackground;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Câu số & Điểm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Câu ${question.order}',
                  style: AppTypography.headlineSmall().copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: warningBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${question.score} điểm',
                  style: AppTypography.labelSmall().copyWith(
                    color: warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nội dung câu hỏi
          MathTextBuilder(
            text: question.content,
            style: AppTypography.bodyLarge().copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
                color: warningBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: warningColor.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bạn chưa chọn đáp án',
                    style: AppTypography.labelMedium().copyWith(
                      color: warningColor,
                    ),
                  ),
                ],
              ),
            ),

          // Danh sách đáp án
          _buildReviewOptions(question, userAnswer, isDark),
        ],
      ),
    );
  }

  Widget _buildReviewOptions(
    QuestionEntity question,
    dynamic userAnswer,
    bool isDark,
  ) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final errorBg = isDark
        ? AppColors.darkErrorBackground
        : AppColors.errorBackground;
    final surfaceVariant = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest;
    final borderCol = Theme.of(context).colorScheme.outlineVariant;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

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
            isDark: isDark,
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
                  ? surfaceVariant
                  : (isCorrect
                        ? successColor.withValues(alpha: 0.05)
                        : errorBg),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !isSelected
                    ? borderCol
                    : (isCorrect
                          ? successColor.withValues(alpha: 0.5)
                          : errorColor),
                width: (!isCorrect && isSelected) ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    optionText,
                    style: AppTypography.bodyMedium().copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? successColor : errorColor,
                  ),
                if (!isSelected)
                  Text(
                    'Bỏ qua',
                    style: AppTypography.labelSmall().copyWith(
                      color: textSecondary,
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
              ? surfaceVariant
              : (isCorrect ? successColor.withValues(alpha: 0.05) : errorBg),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (userAnswer == null || userAnswer == '')
                ? borderCol
                : (isCorrect
                      ? successColor.withValues(alpha: 0.5)
                      : errorColor),
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
    required bool isDark,
  }) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final errorBg = isDark
        ? AppColors.darkErrorBackground
        : AppColors.errorBackground;

    Color bgColor = Theme.of(context).colorScheme.surface;
    Color borderColor = Theme.of(context).colorScheme.outlineVariant;
    Color textColor = Theme.of(context).colorScheme.onSurface;
    Color circleBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    Color circleText = Theme.of(context).colorScheme.onSurfaceVariant;
    IconData? suffixIcon;
    Color? suffixColor;

    if (isCorrectAnswer) {
      // Đáp án đúng luôn được đánh dấu xanh (nhạt hơn)
      bgColor = successColor.withValues(alpha: 0.05);
      borderColor = successColor.withValues(alpha: 0.5);
      circleBg = successColor.withValues(alpha: 0.1);
      circleText = successColor;
      suffixIcon = Icons.check_circle_rounded;
      suffixColor = successColor;
    } else if (isSelected && !isCorrectAnswer) {
      // Đáp án người dùng chọn bị sai -> Nổi bật hơn với viền đậm
      bgColor = errorBg;
      borderColor = errorColor;
      circleBg = errorColor;
      circleText = Colors.white;
      suffixIcon = Icons.close_rounded;
      suffixColor = errorColor;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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
                              ..add(
                                FetchExamDetailEvent(
                                  examId: widget.examId,
                                  subjectId: widget.subjectId,
                                ),
                              ),
                          ),
                          BlocProvider(create: (context) => TimerCubit()),
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
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Luyện lại bài',
                    style: AppTypography.labelLarge().copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Luyện đề khác',
                    style: AppTypography.labelLarge().copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/core/widgets/math_text_builder.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart'
    hide SelectAnswerEvent;
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/firebase_image.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/short_answer_input_field.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/submit_exam_dialog.dart';

class ExamDetailScreen extends StatefulWidget {
  final String subjectId;
  final String examId;

  const ExamDetailScreen({
    Key? key,
    required this.subjectId,
    required this.examId,
  }) : super(key: key);

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  List<String> indexToLetter = ['A', 'B', 'C', 'D'];
  int? duration;

  // String? _currentAnswer;
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    context.read<ExamDetailBloc>().add(
      FetchExamDetailEvent(examId: widget.examId, subjectId: widget.subjectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(duration: 90),
      body: BlocBuilder<ExamDetailBloc, ExamDetailState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (BuildContext context, state) {
          if (state is ExamDetailLoading) {
            return Center(child: Center(child: CircularProgressIndicator()));
          } else if (state is ExamDetailLoaded) {
            List<QuestionEntity> questions = state.questions;
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Column(
                    children: [
                      _buildProgressBar(totalQuestion: questions.length),
                      SizedBox(height: 20),
                      _buildQuestionNavigator(
                        lengthNavigator: questions.length,
                      ),

                      SizedBox(height: 20),

                      Expanded(
                        child: _buildQuestionContent(
                          context: context,
                          pageController: _pageController,
                          listQuestion: questions,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar({required int duration}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppAppbar(
        title: 'Đề thi ${widget.examId} - Môn ${widget.subjectId}',
        actions: _timeCountdown(duration: 90),
      ),
    );
  }

  Widget _timeCountdown({required int duration  }) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [Icon(Icons.timer_outlined), Text('$duration phút')],
      ),
    );
  }

  Widget _buildProgressBar({required int totalQuestion}) {
    return BlocSelector<ExamDetailBloc, ExamDetailState, int>(
      selector: (state) {
        if (state is ExamDetailLoaded) {
          // Chỉ đếm những câu đã trả lời thực sự (không phải giá trị null)
          return state.selectedAnswers?.values.where((v) => v != null).length ??
              0;
        }
        return 0;
      },
      builder: (context, totalQuestionAnswered) {
        return Container(
          child: Row(
            children: [
              Text(
                'Câu ${totalQuestionAnswered}/${totalQuestion}',
                style: AppTypography.headlineSmall(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: totalQuestion > 0
                      ? (totalQuestionAnswered / totalQuestion)
                      : 0.0,
                  borderRadius: BorderRadius.circular(30),
                  color: (totalQuestionAnswered > 0)
                      ? AppColors.primary
                      : AppColors.surface,
                  backgroundColor: AppColors.surfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionNavigator({required int lengthNavigator}) {
    return BlocBuilder<ExamDetailBloc, ExamDetailState>(
      buildWhen: (previous, current) {
        if (previous is! ExamDetailLoaded || current is! ExamDetailLoaded) {
          return true;
        }
        return previous.currentIndex != current.currentIndex ||
            previous.selectedAnswers?.length != current.selectedAnswers?.length;
      },
      builder: (context, state) {
        int currentIndex = 0;
        Map<int, dynamic> selectedAnswers = {};
        if (state is ExamDetailLoaded) {
          currentIndex = state.currentIndex;
          selectedAnswers = state.selectedAnswers ?? {};
        }
        return Container(
          width: double.infinity,
          height: 40,
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            controller: _scrollController,
            itemCount: lengthNavigator,
            scrollDirection: Axis.horizontal,

            itemBuilder: (context, index) {
              bool isAnswered = selectedAnswers[index + 1] != null;
              bool isCurrent = currentIndex == index;

              Color bgColor = isCurrent
                  ? AppColors
                        .background //
                  : (isAnswered ? AppColors.primary : AppColors.surfaceVariant);

              Color textColor = isCurrent
                  ? AppColors.primary
                  : (isAnswered ? Colors.white : AppColors.textSecondary);

              Color borderColor = isCurrent
                  ? AppColors.primary
                  : Colors.transparent;

              return InkWell(
                onTap: () => _pageController.jumpToPage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 2),

                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: AppTypography.headlineSmall().copyWith(
                        color: textColor,
                        fontWeight: isCurrent
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },

            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 5);
            },
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    int index,
    QuestionEntity question,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        // height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 3),
        ),
        child: Column(
          spacing: 20,
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Câu $index',
                    style: AppTypography.headlineSmall().copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      question.score.toString(),
                      style: AppTypography.labelSmall(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MathTextBuilder(
              text: question.content,
              style: AppTypography.headlineMedium(),
            ),
            (question.imageUrl != null && question.imageUrl!.isNotEmpty)
                ? Center(child: FirebaseImage(imageUrl: question.imageUrl!))
                : SizedBox.shrink(),

            BlocSelector<ExamDetailBloc, ExamDetailState, dynamic>(
              selector: (state) {
                if (state is ExamDetailLoaded) {
                  return state.selectedAnswers?[question.order];
                }
                return null;
              },
              builder: (context, answerIndex) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildAnswerSection(question, answerIndex),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 26),
      margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.01),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonAction(
            label: 'TRƯỚC',
            onTap: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          Spacer(),
          _buildButtonAction(
            label: 'NỘP BÀI',
            onTap: () {
              final state = context.read<ExamDetailBloc>().state;
              if (state is ExamDetailLoaded) {
                final total = state.questions.length;
                final answered = state.selectedAnswers!.values
                    .where((v) => v != null)
                    .length;

                showDialog(
                  context: context,
                  builder: (context) {
                    return SubmitExamDialog(
                      totalQuestions: total,
                      answeredQuestions: answered,
                      timeLeft:
                          '14:14', // Đang để tạm thời, sau này lấy từ bộ đếm ngược
                      onSubmit: () {
                        // TODO: Gọi sự kiện nộp bài chính thức
                        // context.read<ExamDetailBloc>().add(SubmitExamEvent());
                      },
                    );
                  },
                );
              }
            },
          ),
          Spacer(),
          _buildButtonAction(
            label: 'SAU',
            onTap: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAction({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      // elevation: 1,
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.labelMedium(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent({
    required BuildContext context,
    required PageController pageController,
    required List<QuestionEntity> listQuestion,
  }) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.sizeOf(context).height  * 0.00333,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          context.read<ExamDetailBloc>().add(
            ChangeQuestionEvent(newIndex: index),
          );
          _scrollToCurrentQuestion(index);
        },
        itemCount: listQuestion.length,
        itemBuilder: (context, index) {
          return _buildQuestionCard(context, index + 1, listQuestion[index]);
        },
      ),
    );
  }

  void _scrollToCurrentQuestion(int index) {
    const itemWidth = 40.0;
    const spacing = 8.0;

    final screenWidth = MediaQuery.of(context).size.width;

    final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    offset.clamp(0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      offset,

      duration: const Duration(milliseconds: 300),

      curve: Curves.easeInOut,
    );
  }

  Widget _buildAnswerSection(QuestionEntity question, dynamic userAnswer) {
    switch (question.type) {
      case 'multiple_choice':
        return _buildMultipleChoiceAnswers(question, userAnswer);
      case 'true_false':
        return _buildTrueFalseAnswers(question, userAnswer);
      case 'short_answer':
        return _buildShortAnswerInput(question, userAnswer);
      default:
        return const SizedBox();
    }
  }

  // 4.1. Giao diện PHẦN I: Trắc nghiệm lựa chọn (A, B, C, D)
  Widget _buildMultipleChoiceAnswers(
    QuestionEntity question,
    dynamic userAnswer,
  ) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final letter = indexToLetter[index];
        final optionText = question.options[index];
        final isSelected = userAnswer == letter;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: InkWell(
            onTap: () {
              context.read<ExamDetailBloc>().add(
                SelectAnswerEvent(
                  questionIndex: question.order,
                  answerIndex: letter,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      optionText,
                      style: AppTypography.bodyLarge().copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // 4.2. Giao diện PHẦN II: Trắc nghiệm Đúng / Sai (Bảng lựa chọn cho 4 ý)
  Widget _buildTrueFalseAnswers(QuestionEntity question, dynamic userAnswer) {
    final Map<String, bool> answers = Map<String, bool>.from(
      userAnswer as Map? ?? {},
    );
    final keys = ['a', 'b', 'c', 'd'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Chọn Đúng hoặc Sai cho mỗi ý kiến dưới đây:',
            style: AppTypography.headlineSmall().copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...List.generate(keys.length, (index) {
          final key = keys[index];
          final optionText = question.options[index];
          final currentSelection = answers[key];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(optionText, style: AppTypography.bodyLarge()),
                ),
                const SizedBox(width: 8),
                // Nút Đúng
                _buildTrueFalseOptionButton(
                  label: 'Đúng',
                  isSelected: currentSelection == true,
                  selectedColor: Colors.green,
                  onTap: () {
                    answers[key] = true;
                    context.read<ExamDetailBloc>().add(
                      SelectAnswerEvent(
                        questionIndex: question.order,
                        answerIndex: answers,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Nút Sai
                _buildTrueFalseOptionButton(
                  label: 'Sai',
                  isSelected: currentSelection == false,
                  selectedColor: Colors.red,
                  onTap: () {
                    answers[key] = false;
                    context.read<ExamDetailBloc>().add(
                      SelectAnswerEvent(
                        questionIndex: question.order,
                        answerIndex: answers,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrueFalseOptionButton({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 4.3. Giao diện PHẦN III: Trắc nghiệm điền câu trả lời ngắn
  Widget _buildShortAnswerInput(QuestionEntity question, dynamic userAnswer) {
    return ShortAnswerInputField(
      question: question,
      initialValue: userAnswer as String? ?? '',
      onChanged: (value) {
        context.read<ExamDetailBloc>().add(
          SelectAnswerEvent(
            questionIndex: question.order,
            answerIndex: value.trim(),
          ),
        );
      },
    );
  }
}

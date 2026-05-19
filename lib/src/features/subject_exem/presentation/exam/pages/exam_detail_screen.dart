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
      appBar: _buildAppBar(),
      body: BlocBuilder<ExamDetailBloc, ExamDetailState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (BuildContext context, state) {
          if (state is ExamDetailLoading)
            return Center(child: Center(child: CircularProgressIndicator()));
          else if (state is ExamDetailLoaded) {
            List<QuestionEntity> questions = state.questions;
            print(state.selectedAnswers![state.currentIndex + 1]);
            print(state.selectedAnswers![state.currentIndex + 1] != null);
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

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppAppbar(
        title: 'Đề thi ${widget.examId} - Môn ${widget.subjectId}',
        actions: _timeCountdown(),
      ),
    );
  }

  Widget _timeCountdown() {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [Icon(Icons.timer_outlined), Text('14:14')],
      ),
    );
  }

  Widget _buildProgressBar({required int totalQuestion}) {
    return BlocSelector<ExamDetailBloc, ExamDetailState, int>(
      selector: (state) {
        if (state is ExamDetailLoaded) {
          return state.selectedAnswers?.length ?? 0;
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
                  value: (totalQuestionAnswered) / 50,
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
        Map<int, int?> selectedAnswers = {};
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
          border: BoxBorder.all(color: AppColors.border, width: 3),
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
                ? CachedNetworkImage(
                    imageUrl: question.imageUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  )
                : SizedBox.shrink(),

            BlocSelector<ExamDetailBloc, ExamDetailState, int?>(
              selector: (state) {
                if (state is ExamDetailLoaded) {
                  return state.selectedAnswers?[question.order];
                }
                return null;
              },
              builder: (context, answerIndex) {
                return Column(
                  spacing: 12,
                  children: List.generate(question.options.length, (index) {
                    return _buildAnswerSelect(
                      context: context,
                      optionIndex: index,
                      optionText: question.options[index],
                      userAnswer: answerIndex,
                      questionOrder: question.order,
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSelect({
    required BuildContext context,
    required int optionIndex,
    required String optionText,
    required int? userAnswer,
    required int questionOrder,
  }) {
    final String letter = String.fromCharCode(65 + optionIndex);
    final String cleanedText = optionText.replaceFirst(
      RegExp(r'^[A-Z]\.\s*'),
      '',
    );
    bool isSelected = optionIndex == userAnswer;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.read<ExamDetailBloc>().add(
            SelectAnswerEvent(
              questionIndex: questionOrder,
              answerIndex: optionIndex,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: BoxBorder.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1, // Viền đậm hơn khi chọn
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 40,
                height: 40, // Cố định kích thước hình tròn chữ cái
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.darkTextSecondary.withValues(alpha: 0.2),
                  border: BoxBorder.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: AppTypography.headlineSmall().copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: MathTextBuilder(
                  text: cleanedText,
                  style: AppTypography.headlineSmall().copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
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
              showDialog(
                context: context,
                builder: (context) {
                  return SubmitExamDialog();
                },
              );
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
            border: BoxBorder.all(color: AppColors.border, width: 1.5),
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
}

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
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/timer_cubit/timer_cubit.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/firebase_image.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/short_answer_input_field.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/submit_exam_dialog.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/exam_result_screen.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/widgets/save_exam_button.dart';

class ExamDetailScreen extends StatefulWidget {
  final String subjectId;
  final String examId;
  final String title;
  final int duration;

  const ExamDetailScreen({
    Key? key,
    required this.subjectId,
    required this.title,
    required this.examId,
    required this.duration,
  }) : super(key: key);

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> with WidgetsBindingObserver {
  List<String> indexToLetter = ['A', 'B', 'C', 'D'];
  int? duration;

  // String? _currentAnswer;
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<TimerCubit>().startTimer(widget.duration);
    context.read<ExamDetailBloc>().add(
      FetchExamDetailEvent(examId: widget.examId, subjectId: widget.subjectId),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TimerCubit>().onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop == true) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
      body: BlocListener<TimerCubit, int>(
        listener: (context, remainingSeconds) {
          if (remainingSeconds == 0) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text('Hết giờ!'),
                content: Text('Thời gian làm bài đã kết thúc. Hệ thống tự động nộp bài.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Gọi sự kiện SubmitExamEvent và chuyển hướng
                    },
                    child: Text('Đóng'),
                  )
                ],
              ),
            );
          }
        },
        child: BlocBuilder<ExamDetailBloc, ExamDetailState>(
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
    ),
      bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thoát bài thi?'),
          content: Text('Bạn đang làm bài thi. Nếu thoát bây giờ, kết quả của bạn sẽ không được lưu. Bạn có chắc chắn muốn thoát?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Tiếp tục làm bài'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Thoát',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    int duration = widget.duration;
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppAppbar(
        title: 'Đề thi ${widget.title} ',
        actions: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ExamDetailBloc, ExamDetailState>(
              builder: (context, state) {
                int totalQs = 0;
                if (state is ExamDetailLoaded) {
                  totalQs = state.questions.length;
                }
                return SaveExamButton(
                  examId: widget.examId,
                  title: widget.title,
                  subjectId: widget.subjectId,
                  duration: widget.duration,
                  totalQuestions: totalQs,
                );
              },
            ),
            _timeCountdown(duration: duration),
          ],
        ),
      ),
    );
  }

  Widget _timeCountdown({required int duration}) {
    return BlocBuilder<TimerCubit, int>(
      builder: (context, remainingSeconds) {
        if (remainingSeconds < 0) return const SizedBox();
        
        final minutes = (remainingSeconds / 60).floor().toString().padLeft(2, '0');
        final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
        final isWarning = remainingSeconds <= 60; // Báo đỏ khi còn dưới 1 phút

        return Container(
          margin: EdgeInsets.only(right: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(
                Icons.timer_outlined, 
                color: isWarning ? Theme.of(context).colorScheme.error : null,
              ), 
              Text(
                '$minutes:$seconds',
                style: TextStyle(
                  color: isWarning ? Theme.of(context).colorScheme.error : null,
                  fontWeight: isWarning ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        );
      },
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
                'Câu $totalQuestionAnswered/$totalQuestion',
                style: AppTypography.bodySmall(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: totalQuestion > 0
                      ? (totalQuestionAnswered / totalQuestion)
                      : 0.0,
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
                  ? Theme.of(context).colorScheme.primaryContainer
                  : (isAnswered ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest);

              Color textColor = isCurrent
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : (isAnswered ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant);

              Color borderColor = isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant;

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
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: AppTypography.bodySmall().copyWith(
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
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
                      color: Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkWarningBackground
                        : AppColors.warningBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkWarning
                          : AppColors.warning,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      question.score.toString(),
                      style: AppTypography.labelSmall(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MathTextBuilder(
              text: question.content,
              style: AppTypography.bodyLarge(),
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

  Widget _buildBottomNav(BuildContext context) {
    return BlocBuilder<ExamDetailBloc, ExamDetailState>(
      builder: (context, state) {
        int currentIndex = 0;
        int totalQuestions = 0;

        if (state is ExamDetailLoaded) {
          currentIndex = state.currentIndex;
          totalQuestions = state.questions.length;
        }

        bool isFirstQuestion = currentIndex == 0;
        bool isLastQuestion = totalQuestions > 0 && currentIndex == totalQuestions - 1;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark ? 0.28 : 0.08,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Nút TRƯỚC
                _buildNavigationButton(
                  context: context,
                  label: 'TRƯỚC',
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: isFirstQuestion
                      ? null
                      : () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  isIconRight: false,
                ),
                
                const SizedBox(width: 12),
                
                // Nút NỘP BÀI
                Expanded(
                  child: _buildSubmitButton(
                    context: context,
                    onTap: () {
                      if (state is ExamDetailLoaded) {
                        final total = state.questions.length;
                        final answered = state.selectedAnswers!.values
                            .where((v) => v != null)
                            .length;

                        final remaining = context.read<TimerCubit>().state;
                        final timeLeftStr = remaining > 0 
                            ? '${(remaining / 60).floor().toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}'
                            : '00:00';

                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return SubmitExamDialog(
                              totalQuestions: total,
                              answeredQuestions: answered,
                              timeLeft: timeLeftStr,
                              onSubmit: () {
                                context.read<TimerCubit>().stopTimer();
                                
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ExamResultScreen(
                                      questions: state.questions,
                                      userAnswers: state.selectedAnswers ?? {},
                                      timeTakenInSeconds: (widget.duration * 60) - remaining,
                                      subjectId: widget.subjectId,
                                      examId: widget.examId,
                                      title: widget.title,
                                      duration: widget.duration,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Nút SAU
                _buildNavigationButton(
                  context: context,
                  label: 'SAU',
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: isLastQuestion
                      ? null
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  isIconRight: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton({required VoidCallback onTap, required BuildContext context}) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'NỘP BÀI',
                style: AppTypography.labelMedium().copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isIconRight,
  }) {
    final bool isDisabled = onTap == null;
    final Color contentColor = isDisabled 
        ? Theme.of(context).disabledColor
        : Theme.of(context).colorScheme.onPrimaryContainer;
    final Color bgColor = isDisabled 
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primaryContainer;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isIconRight) Icon(icon, size: 18, color: contentColor),
              if (!isIconRight) const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelMedium().copyWith(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isIconRight) const SizedBox(width: 4),
              if (isIconRight) Icon(icon, size: 18, color: contentColor),
            ],
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
        allowImplicitScrolling: true, // Cho phép tải trước các trang lân cận (precaching)
        onPageChanged: (index) {
          context.read<ExamDetailBloc>().add(
            ChangeQuestionEvent(newIndex: index),
          );
          _scrollToCurrentQuestion(index);
        },
        itemCount: listQuestion.length,
        itemBuilder: (context, index) {
          return KeepAliveWrapper(
            child: _buildQuestionCard(context, index + 1, listQuestion[index]),
          );
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

  //Trắc nghiệm lựa chọn (A, B, C, D)
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
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
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
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  //Trắc nghiệm Đúng / Sai (Bảng lựa chọn cho 4 ý)
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
              color: Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(optionText, style: AppTypography.bodyLarge().copyWith(color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Nút Đúng
                    Expanded(
                      child: _buildTrueFalseOptionButton(
                        context: context,
                        label: 'Đúng',
                        isSelected: currentSelection == true,
                        selectedColor: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSuccess
                            : AppColors.success,
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
                    ),
                    const SizedBox(width: 8),
                    // Nút Sai
                    Expanded(
                      child: _buildTrueFalseOptionButton(
                        context: context,
                        label: 'Sai',
                        isSelected: currentSelection == false,
                        selectedColor: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkError
                            : AppColors.error,
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
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrueFalseOptionButton({
    required BuildContext context,
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
          color: isSelected ? selectedColor.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surfaceContainer,
          border: Border.all(
            color: isSelected ? selectedColor : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? selectedColor : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //Trắc nghiệm điền câu trả lời ngắn
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

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}


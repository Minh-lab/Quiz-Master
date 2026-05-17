import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
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
  int _currentIndex = 0;
  Map<int, int?> _selectedAnswers = {};
  // String? _currentAnswer;
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                _buildProgressBar(),
                SizedBox(height: 20),
                _buildQuestionNavigator(),
                SizedBox(height: 20),

                Expanded(
                  child: _buildQuestionContent(
                    context,
                    _pageController,
                    'Đạo hàm của hàm số x là:',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
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

  Widget _buildProgressBar() {
    return Container(
      child: Row(
        children: [
          Text(
            'Câu ${_currentIndex + 1}/50',
            style: AppTypography.headlineSmall(),
          ),
          SizedBox(width: 20),
          Expanded(
            child: LinearProgressIndicator(
              minHeight: 10,
              value: (_selectedAnswers.length) / 50,
              borderRadius: BorderRadius.circular(30),
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNavigator() {
    return Container(
      width: double.infinity,
      height: 40,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: 50,
        scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _pageController.jumpToPage(index),
            child: Container(
              width: 30,

              // height: 40,
              // padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: AppTypography.headlineSmall(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                // color: AppColors.primary,
                color: index == 0 || index != 0
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
      ),
    );
  }

  Widget _buildQuestionCard(int index, String nameQuestion) {
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
                      '0.25 điểm',
                      style: AppTypography.labelSmall(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(nameQuestion, style: AppTypography.headlineMedium()),
            _buildAnswerSelect('A'),
            _buildAnswerSelect('B'),
            _buildAnswerSelect('C'),
            _buildAnswerSelect('D'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSelect(String answer) {
    int? selectedAnswer;
    switch (answer) {
      case 'A':
        selectedAnswer = 0;
        break;
      case 'B':
        selectedAnswer = 1;
        break;
      case 'C':
        selectedAnswer = 2;
        break;
      case 'D':
        selectedAnswer = 3;
        break;
    }
    return Material(
      borderRadius: BorderRadius.circular(16),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            _selectedAnswers[_currentIndex] = selectedAnswer;
          });
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: BoxBorder.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedAnswers[_currentIndex] == selectedAnswer
                      ? AppColors.primary.withValues(alpha: 0.8)
                      : AppColors.darkTextSecondary.withValues(alpha: 0.2),
                  border: BoxBorder.all(color: AppColors.border, width: 3),
                ),
                child: Center(
                  child: Text(
                    answer,
                    style: AppTypography.headlineSmall().copyWith(
                      color: _selectedAnswers[_currentIndex] == answer
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text('0', style: AppTypography.headlineSmall()),
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

  Widget _buildQuestionContent(
    BuildContext context,
    PageController _pageController,
    String nameQuestion,
  ) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * nameQuestion.length * 0.00333,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _scrollToCurrentQuestion(index);
        },
        itemCount: 50,
        itemBuilder: (context, index) {
          return _buildQuestionCard(index + 1, nameQuestion);
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

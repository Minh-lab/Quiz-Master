import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

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
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          children: [
            _buildProgressBar(),
            SizedBox(height: 20),
            _buildQuestionNavigator(),
            SizedBox(height: 20),
            _buildQuestionCard(1),
          ],
        ),
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
          Text('Câu 1/50', style: AppTypography.headlineSmall()),
          SizedBox(width: 20),
          Expanded(
            child: LinearProgressIndicator(
              minHeight: 10,
              value: 40 / 50,
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
        itemCount: 50,
        scrollDirection: Axis.horizontal,
        // controller: pageController,
        itemBuilder: (context, index) {
          return Container(
            width: 30,

            // height: 40,
            // padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                index.toString(),
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
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    return Container(
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
          Text(
            'Đạo hàm của hàm số x là?',
            style: AppTypography.headlineMedium(),
          ),
          _buildAnswerSelect('A'),
          _buildAnswerSelect('B'),
          _buildAnswerSelect('C'),
          _buildAnswerSelect('D'),
        ],
      ),
    );
  }

  Widget _buildAnswerSelect(String answer) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(color: AppColors.border, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkTextSecondary.withValues(alpha: 0.2),
              border: BoxBorder.all(color: AppColors.border, width: 3),
            ),
            child: Center(
              child: Text(answer, style: AppTypography.headlineSmall()),
            ),
          ),
          SizedBox(width: 10),
          Text('0', style: AppTypography.headlineSmall()),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.12,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildButtonAction('TRƯỚC'),
          Spacer(),
          _buildButtonAction('NỘP BÀI'),
          Spacer(),
          _buildButtonAction('SAU'),
        ],
      ),
    );
  }

  Widget _buildButtonAction(String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(color: AppColors.border, width: 3),
      ),
      child: Center(
        child: Text(label.toUpperCase(), style: AppTypography.headlineSmall()),
      ),
    );
  }
}

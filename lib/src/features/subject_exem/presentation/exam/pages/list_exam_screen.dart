import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/list_exam_dialog.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/exam_card.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/widgets/save_exam_button.dart';

class ListExam extends StatelessWidget {
  final String subjectId;
  const ListExam({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: 'Luyện đề môn $subjectId'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<ExamBloc, ExamState>(
          builder: (BuildContext context, state) {
            switch (state) {
              case ExamLoading():
                return const Center(child: CircularProgressIndicator());
              case ExamLoaded():
                {
                  final exams = state.exams;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ExamCard(
                        title: exams[index].title,
                        numberQuestion: exams[index].totalQuestions.toString(),
                        time: exams[index].duration.toString(),
                        trailing: SaveExamButton(
                          examId: exams[index].id,
                          title: exams[index].title,
                          subjectId: subjectId,
                          duration: exams[index].duration,
                          totalQuestions: exams[index].totalQuestions,
                        ),
                        onTap: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return ListExamDialog(
                                exam: exams[index],
                                onConfirm: () {
                                  Navigator.pop(dialogContext, true);
                                },
                              );
                            },
                          );

                          if (result == true && context.mounted) {
                            context.push(
                              AppRouter.exambyIdDetail(
                                subjectId,
                                exams[index].id,
                              ),
                              extra: exams[index],
                            );
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8);
                    },
                    itemCount: exams.length,
                  );
                }
              case ExamError():
                final errorState = state as ExamError;
                return Center(child: Text("Lỗi: ${errorState.messageError}"));

                ;
            }
            return Container(child: const Text('Erorr'));
          },
        ),
      ),
    );
  }

  
}

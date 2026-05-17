import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/exam_card.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/subject_card.dart';

class ListExam extends StatelessWidget {
  final String subjectId;
  const ListExam({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ExamBloc>().add(FetchExamPreviewEvent(subjectId: subjectId));
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
                        onTap: () => context.push(
                          AppRouter.exambyIdDetail(subjectId, exams[index].id),
                          extra: exams[index],
                        ),
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

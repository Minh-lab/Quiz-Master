import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/subject.dart';

class SubjectModel extends SubjectEntity {
  SubjectModel({
    required super.id,
    required super.name,
    required super.iconName,
    required super.themeColor,
    required super.order,
    required super.countExams,
  });
  factory SubjectModel.fromFireStore(Map<String, dynamic> json) => SubjectModel(
    id: json['id'],
    name: json['name'] ?? '',
    iconName: json['icon_name'] ?? 'null',
    themeColor: json['theme_color'] ?? "",
    order: json['order'] ?? 99,
    countExams: json['count_exams'] ?? 0,
  );
  SubjectEntity toEntity() => SubjectEntity(
    id: id,
    name: name,
    iconName: iconName,
    themeColor: themeColor,
    order: order,
    countExams: countExams,
  );
}

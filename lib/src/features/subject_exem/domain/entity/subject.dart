import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String themeColor;
  final int order;
  final int countExams;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.iconName,
    required this.themeColor,
    required this.order,
    required this.countExams
  });
  @override
  // TODO: implement props
  List<Object?> get props => [id, name, iconName, themeColor, order, countExams];
}
import 'package:dartz/dartz.dart';

abstract class ISubjectRepository {
  Future<Either> getSubjects();

}

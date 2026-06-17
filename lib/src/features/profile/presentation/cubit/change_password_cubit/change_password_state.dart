import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String errorMessage;

  const ChangePasswordError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

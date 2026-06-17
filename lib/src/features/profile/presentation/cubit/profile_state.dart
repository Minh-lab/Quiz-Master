abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {}
class ProfileUpdateFailure extends ProfileState {
  final String errorMessage;
  ProfileUpdateFailure(this.errorMessage);
}

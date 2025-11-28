abstract class RecoverPasswordState {}

class RecoverPasswordInitial extends RecoverPasswordState {}

class RecoverPasswordLoading extends RecoverPasswordState {}

class RecoverPasswordSuccess extends RecoverPasswordState {
  final String message;
  RecoverPasswordSuccess(this.message);
}

class RecoverPasswordError extends RecoverPasswordState {
  final String message;
  RecoverPasswordError(this.message);
}

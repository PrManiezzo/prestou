abstract class ConfirmAccountState {}

class ConfirmAccountInitial extends ConfirmAccountState {}

class ConfirmAccountLoading extends ConfirmAccountState {}

class ConfirmAccountSuccess extends ConfirmAccountState {
  final String message;
  ConfirmAccountSuccess(this.message);
}

class ConfirmAccountError extends ConfirmAccountState {
  final String message;
  ConfirmAccountError(this.message);
}

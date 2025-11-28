abstract class ResendCodeState {}

class ResendCodeInitial extends ResendCodeState {}

class ResendCodeLoading extends ResendCodeState {}

class ResendCodeSuccess extends ResendCodeState {
  final String message;
  ResendCodeSuccess(this.message);
}

class ResendCodeError extends ResendCodeState {
  final String message;
  ResendCodeError(this.message);
}

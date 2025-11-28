abstract class ResendCodeEvent {}

class ResendCodeSubmit extends ResendCodeEvent {
  final String whatsapp;
  ResendCodeSubmit(this.whatsapp);
}

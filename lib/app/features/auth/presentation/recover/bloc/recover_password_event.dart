abstract class RecoverPasswordEvent {}

class RecoverPasswordSubmit extends RecoverPasswordEvent {
  final String whatsapp;
  RecoverPasswordSubmit(this.whatsapp);
}

abstract class ConfirmAccountEvent {}

class ConfirmAccountSubmit extends ConfirmAccountEvent {
  final String whatsapp;
  final String code;
  ConfirmAccountSubmit({required this.whatsapp, required this.code});
}

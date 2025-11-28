abstract class ConfirmPasswordEvent {}

class ConfirmPasswordSubmit extends ConfirmPasswordEvent {
  final String whatsapp;
  final String code;
  final String password;
  ConfirmPasswordSubmit({
    required this.whatsapp,
    required this.code,
    required this.password,
  });
}

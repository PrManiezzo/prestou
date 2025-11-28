abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String whatsapp;
  final String password;

  AuthLoginEvent(this.whatsapp, this.password);
}

class AuthCheckLoggedEvent extends AuthEvent {}

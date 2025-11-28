abstract class RegisterEvent {}

class RegisterSubmit extends RegisterEvent {
  final String whatsapp;
  final String name;
  final String password;
  final String email;
  final int age;

  RegisterSubmit({
    required this.whatsapp,
    required this.name,
    required this.password,
    required this.email,
    required this.age,
  });
}

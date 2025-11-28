import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _repo = AuthRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmit>(_submit);
  }

  Future<void> _submit(
    RegisterSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final res = await _repo.register(
        whatsapp: event.whatsapp,
        name: event.name,
        password: event.password,
        email: event.email,
        age: event.age,
      );
      final msg = (res['message'] ?? 'Cadastro realizado com sucesso')
          .toString();
      emit(RegisterSuccess(msg));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}

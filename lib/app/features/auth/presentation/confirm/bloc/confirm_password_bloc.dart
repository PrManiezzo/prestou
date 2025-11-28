import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repository.dart';
import 'confirm_password_event.dart';
import 'confirm_password_state.dart';

class ConfirmPasswordBloc
    extends Bloc<ConfirmPasswordEvent, ConfirmPasswordState> {
  final _repo = AuthRepository();

  ConfirmPasswordBloc() : super(ConfirmPasswordInitial()) {
    on<ConfirmPasswordSubmit>(_submit);
  }

  Future<void> _submit(
    ConfirmPasswordSubmit event,
    Emitter<ConfirmPasswordState> emit,
  ) async {
    emit(ConfirmPasswordLoading());
    try {
      final res = await _repo.confirmNewPassword(
        whatsapp: event.whatsapp,
        code: event.code,
        password: event.password,
      );
      final msg = (res['message'] ?? 'Senha alterada com sucesso').toString();
      emit(ConfirmPasswordSuccess(msg));
    } catch (e) {
      emit(ConfirmPasswordError(e.toString()));
    }
  }
}

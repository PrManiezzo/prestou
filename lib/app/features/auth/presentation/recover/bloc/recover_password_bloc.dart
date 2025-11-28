import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repository.dart';
import 'recover_password_event.dart';
import 'recover_password_state.dart';

class RecoverPasswordBloc
    extends Bloc<RecoverPasswordEvent, RecoverPasswordState> {
  final _repo = AuthRepository();

  RecoverPasswordBloc() : super(RecoverPasswordInitial()) {
    on<RecoverPasswordSubmit>(_submit);
  }

  Future<void> _submit(
    RecoverPasswordSubmit event,
    Emitter<RecoverPasswordState> emit,
  ) async {
    emit(RecoverPasswordLoading());
    try {
      final res = await _repo.requestNewPassword(event.whatsapp);
      final msg = (res['message'] != null)
          ? res['message'].toString()
          : 'Solicitação enviada com sucesso';
      emit(RecoverPasswordSuccess(msg));
    } catch (e) {
      emit(RecoverPasswordError(e.toString()));
    }
  }
}

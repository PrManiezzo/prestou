import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repository.dart';
import 'resend_code_event.dart';
import 'resend_code_state.dart';

class ResendCodeBloc extends Bloc<ResendCodeEvent, ResendCodeState> {
  final _repo = AuthRepository();

  ResendCodeBloc() : super(ResendCodeInitial()) {
    on<ResendCodeSubmit>(_submit);
  }

  Future<void> _submit(
    ResendCodeSubmit event,
    Emitter<ResendCodeState> emit,
  ) async {
    emit(ResendCodeLoading());
    try {
      final res = await _repo.resendValidationCode(event.whatsapp);
      final msg = (res['message'] ?? 'Código reenviado com sucesso').toString();
      emit(ResendCodeSuccess(msg));
    } catch (e) {
      emit(ResendCodeError(e.toString()));
    }
  }
}

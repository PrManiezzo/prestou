import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repository.dart';
import 'confirm_account_event.dart';
import 'confirm_account_state.dart';

class ConfirmAccountBloc
    extends Bloc<ConfirmAccountEvent, ConfirmAccountState> {
  final _repo = AuthRepository();

  ConfirmAccountBloc() : super(ConfirmAccountInitial()) {
    on<ConfirmAccountSubmit>(_submit);
  }

  Future<void> _submit(
    ConfirmAccountSubmit event,
    Emitter<ConfirmAccountState> emit,
  ) async {
    emit(ConfirmAccountLoading());
    try {
      final res = await _repo.confirmNewAccount(
        whatsapp: event.whatsapp,
        code: event.code,
      );
      final msg = (res['message'] ?? 'Conta confirmada com sucesso').toString();
      emit(ConfirmAccountSuccess(msg));
    } catch (e) {
      emit(ConfirmAccountError(e.toString()));
    }
  }
}

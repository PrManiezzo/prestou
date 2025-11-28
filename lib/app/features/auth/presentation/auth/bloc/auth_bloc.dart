import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestou/app/features/auth/data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final repo = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_login);
    on<AuthCheckLoggedEvent>(_checkLogged);
  }

  Future<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repo.login(event.whatsapp, event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _checkLogged(
    AuthCheckLoggedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final logged = await repo.isLogged();
    logged ? emit(AuthLogged()) : emit(AuthNotLogged());
  }
}

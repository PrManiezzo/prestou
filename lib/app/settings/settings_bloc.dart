import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
    : super(SettingsState(isDarkTheme: false, languageCode: "pt")) {
    on<ChangeThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
    });

    on<ChangeLanguageEvent>((event, emit) {
      emit(state.copyWith(languageCode: event.languageCode));
    });
  }
}

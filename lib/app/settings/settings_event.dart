abstract class SettingsEvent {}

class ChangeThemeEvent extends SettingsEvent {}

class ChangeLanguageEvent extends SettingsEvent {
  final String languageCode;
  ChangeLanguageEvent(this.languageCode);
}

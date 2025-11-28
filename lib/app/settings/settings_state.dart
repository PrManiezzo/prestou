class SettingsState {
  final bool isDarkTheme;
  final String languageCode;

  SettingsState({required this.isDarkTheme, required this.languageCode});

  SettingsState copyWith({bool? isDarkTheme, String? languageCode}) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

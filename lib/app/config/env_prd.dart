// Production Environment Configuration
class EnvConfig {
  static const String apiBaseUrl = 'https://api.prestou.com';
  static const String environment = 'production';
  static const bool enableDebugLogs = false;
  static const int apiTimeoutSeconds = 15;

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // API Keys (Production)
  static const String? firebaseApiKey = null;
  static const String? googleMapsApiKey = null;
}

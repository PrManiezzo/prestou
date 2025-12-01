// Development Environment Configuration
class EnvConfig {
  static const String apiBaseUrl = 'https://api.prestou.com';
  static const String environment = 'development';
  static const bool enableDebugLogs = true;
  static const int apiTimeoutSeconds = 30;
  
  // Feature Flags
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
  
  // API Keys (Development)
  static const String? firebaseApiKey = null;
  static const String? googleMapsApiKey = null;
}

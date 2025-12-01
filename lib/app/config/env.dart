// Environment Manager
// Import the appropriate env file based on build configuration

// To use different environments, run:
// flutter run --dart-define=ENV=dev
// flutter run --dart-define=ENV=prd

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

class Env {
  static String get apiBaseUrl {
    switch (environment) {
      case 'prd':
      case 'production':
        return 'https://api.prestou.com';
      case 'dev':
      case 'development':
      default:
        return 'https://api.prestou.com';
    }
  }

  static bool get enableDebugLogs {
    switch (environment) {
      case 'prd':
      case 'production':
        return false;
      case 'dev':
      case 'development':
      default:
        return true;
    }
  }

  static int get apiTimeoutSeconds {
    switch (environment) {
      case 'prd':
      case 'production':
        return 15;
      case 'dev':
      case 'development':
      default:
        return 30;
    }
  }

  static bool get enableAnalytics {
    switch (environment) {
      case 'prd':
      case 'production':
        return true;
      case 'dev':
      case 'development':
      default:
        return false;
    }
  }

  static bool get enableCrashReporting {
    switch (environment) {
      case 'prd':
      case 'production':
        return true;
      case 'dev':
      case 'development':
      default:
        return false;
    }
  }

  static String get currentEnvironment => environment;

  static bool get isProduction => environment == 'prd' || environment == 'production';
  static bool get isDevelopment => environment == 'dev' || environment == 'development';
}

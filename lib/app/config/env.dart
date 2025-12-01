// Environment Manager
// IMPORTANTE: Por enquanto, apenas o ambiente de DEV está configurado.
// O ambiente de produção será implementado futuramente.

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

class Env {
  // API Base URL - sempre dev por enquanto
  static String get apiBaseUrl => 'https://api.prestou.com';

  // Debug logs - sempre habilitado (dev apenas)
  static bool get enableDebugLogs => true;

  // Timeout - configuração dev
  static int get apiTimeoutSeconds => 30;

  // Analytics - desabilitado (dev)
  static bool get enableAnalytics => false;

  // Crash Reporting - desabilitado (dev)
  static bool get enableCrashReporting => false;

  // Environment info
  static String get currentEnvironment => 'development';
  static bool get isProduction => false;
  static bool get isDevelopment => true;
}


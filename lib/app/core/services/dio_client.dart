import 'package:dio/dio.dart';
import '../../features/auth/data/auth_local_storage.dart';
import '../../config/env.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: Duration(seconds: Env.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: Env.apiTimeoutSeconds),
    ),
  );

  static void setup() {
    // Interceptor para adicionar token de autenticação
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthLocalStorage().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (Env.enableDebugLogs) {
            print(
                '[${Env.currentEnvironment.toUpperCase()}] ${options.method} ${options.uri}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (Env.enableDebugLogs) {
            print(
                '[${Env.currentEnvironment.toUpperCase()}] Response: ${response.statusCode}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (Env.enableDebugLogs) {
            print(
                '[${Env.currentEnvironment.toUpperCase()}] Error: ${error.message}');
            print(
                '[${Env.currentEnvironment.toUpperCase()}] Response: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }
}

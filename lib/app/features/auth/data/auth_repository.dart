import 'package:dio/dio.dart';
import '../../../core/services/dio_client.dart';
import '../../../core/services/device_info_service.dart';
import 'auth_local_storage.dart';

class AuthRepository {
  final _local = AuthLocalStorage();
  final _deviceInfo = DeviceInfoService();

  Future<Map<String, dynamic>> login(String whatsapp, String password) async {
    try {
      final deviceData = await _deviceInfo.getDeviceInfo();

      final response = await DioClient.dio.post(
        "/auth/login",
        data: {
          "whatsapp": whatsapp,
          "password": password,
          "deviceToken": "fcm_token_abc123xyz789",
          ...deviceData,
        },
      );

      final data = response.data["data"];
      if (data == null) throw Exception("Campo 'data' não existe no response");

      final token = data["accessToken"];
      final user = data["user"];

      if (token == null || token.isEmpty) {
        throw Exception("Token não encontrado no response");
      }

      // SALVA LOGIN
      await _local.saveLogin(token, user, response.data);

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }

  /// verifica se já está logado
  Future<bool> isLogged() async {
    return (await _local.getToken()) != null;
  }

  /// Solicita nova senha via WhatsApp
  Future<Map<String, dynamic>> requestNewPassword(String whatsapp) async {
    try {
      final response = await DioClient.dio.post(
        "/auth/request-new-password",
        data: {"whatsapp": whatsapp},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }

  /// Confirma nova senha informando código recebido
  Future<Map<String, dynamic>> confirmNewPassword({
    required String whatsapp,
    required String code,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/auth/confirm-new-password",
        data: {"whatsapp": whatsapp, "code": code, "password": password},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }

  /// Cria novo usuário
  Future<Map<String, dynamic>> register({
    required String whatsapp,
    required String name,
    required String password,
    required String email,
    required int age,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/users/new-account",
        data: {
          "whatsapp": whatsapp,
          "name": name,
          "password": password,
          "email": email,
          "age": age,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }

  /// Confirma nova conta com código de verificação
  Future<Map<String, dynamic>> confirmNewAccount({
    required String whatsapp,
    required String code,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/users/new-account-confirmation",
        data: {"whatsapp": whatsapp, "code": code},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }

  /// Reenvia código de validação
  Future<Map<String, dynamic>> resendValidationCode(String whatsapp) async {
    try {
      final response = await DioClient.dio.post(
        "/users/resend-validation-code",
        data: {"whatsapp": whatsapp},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Erro de conexão");
    }
  }
}

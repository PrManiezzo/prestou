import 'package:dio/dio.dart';
import 'package:prestou/app/core/services/dio_client.dart';
import 'package:prestou/app/features/advertisements/data/models/advertisement.dart';

class AdvertisementRepository {
  final Dio _dio = DioClient.dio;

  /// POST /advertisements - Criar anúncio
  Future<Advertisement> createAdvertisement({
    required String title,
    required String description,
    double? price,
    required int categoryId,
  }) async {
    try {
      print('Criando anúncio: title=$title, categoryId=$categoryId');
      final response = await _dio.post(
        '/advertisements',
        data: {
          'title': title,
          'description': description,
          'price': price,
          'categoryId': categoryId,
        },
      );
      print('Resposta: ${response.data}');
      return Advertisement.fromJson(response.data);
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw Exception(
          'Erro ao criar anúncio: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Exception: $e');
      throw Exception('Erro ao criar anúncio: $e');
    }
  }

  /// GET /advertisements/category/{categoryId} - Listar anúncios por categoria
  Future<List<Advertisement>> getAdvertisementsByCategory(
      int categoryId) async {
    try {
      print('Buscando anúncios da categoria: $categoryId');
      final response = await _dio.get('/advertisements/category/$categoryId');
      print('Resposta: ${response.data}');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Advertisement.fromJson(json)).toList();
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw Exception(
          'Erro ao buscar anúncios: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Exception: $e');
      throw Exception('Erro ao buscar anúncios: $e');
    }
  }

  /// PATCH /advertisements/{id}/status - Atualizar status do anúncio
  Future<Advertisement> updateAdvertisementStatus({
    required int id,
    required String status,
  }) async {
    try {
      final response = await _dio.patch(
        '/advertisements/$id/status',
        data: {'status': status},
      );
      return Advertisement.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar status do anúncio: $e');
    }
  }

  /// PATCH /admin/advertisements/{id}/ban - Banir anúncio (Admin)
  Future<Advertisement> banAdvertisement(int id) async {
    try {
      final response = await _dio.patch('/admin/advertisements/$id/ban');
      return Advertisement.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao banir anúncio: $e');
    }
  }

  /// PATCH /admin/advertisements/{id}/review - Colocar anúncio em revisão (Admin)
  Future<Advertisement> reviewAdvertisement(int id) async {
    try {
      final response = await _dio.patch('/admin/advertisements/$id/review');
      return Advertisement.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao colocar anúncio em revisão: $e');
    }
  }
}

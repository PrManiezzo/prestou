import 'package:dio/dio.dart';
import 'package:prestou/app/core/services/dio_client.dart';
import 'package:prestou/app/features/advertisements/data/models/advertisement_category.dart';

class AdvertisementCategoryRepository {
  final Dio _dio = DioClient.dio;

  /// GET /advertisements-categories - Listar categorias de anúncios
  Future<List<AdvertisementCategory>> getCategories() async {
    try {
      print('Buscando categorias...');
      final response = await _dio.get('/advertisements-categories');
      print('Resposta: ${response.data}');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AdvertisementCategory.fromJson(json)).toList();
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw Exception(
          'Erro ao buscar categorias: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Exception: $e');
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  /// POST /admin/advertisements-categories - Criar categoria (Admin)
  Future<AdvertisementCategory> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/admin/advertisements-categories',
        data: {
          'name': name,
          'description': description,
        },
      );
      return AdvertisementCategory.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  /// DELETE /admin/advertisements-categories/{id} - Remover categoria (Admin)
  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('/admin/advertisements-categories/$id');
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:prestou/app/core/services/dio_client.dart';
import 'package:prestou/app/features/advertisements/data/models/advertisement_image.dart';

class AdvertisementImageRepository {
  final Dio _dio = DioClient.dio;

  /// POST /advertisements-images - Adicionar imagem ao anúncio
  Future<AdvertisementImage> addImage({
    required int advertisementId,
    required String imageUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/advertisements-images',
        data: {
          'advertisementId': advertisementId,
          'url': imageUrl,
        },
      );
      return AdvertisementImage.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao adicionar imagem: $e');
    }
  }

  /// GET /advertisements-images/{advertisementId} - Listar imagens de um anúncio
  Future<List<AdvertisementImage>> getAdvertisementImages(
      int advertisementId) async {
    try {
      final response =
          await _dio.get('/advertisements-images/$advertisementId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AdvertisementImage.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar imagens: $e');
    }
  }

  /// DELETE /advertisements-images/{id} - Remover imagem
  Future<void> deleteImage(int id) async {
    try {
      await _dio.delete('/advertisements-images/$id');
    } catch (e) {
      throw Exception('Erro ao deletar imagem: $e');
    }
  }
}

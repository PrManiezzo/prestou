import 'package:flutter/material.dart';
import 'package:prestou/app/features/advertisements/data/models/advertisement.dart';
import 'package:prestou/app/features/advertisements/data/models/advertisement_image.dart';
import 'package:prestou/app/features/advertisements/data/repositories/advertisement_image_repository.dart';

class AdvertisementDetailPage extends StatefulWidget {
  final int advertisementId;

  const AdvertisementDetailPage({
    super.key,
    required this.advertisementId,
  });

  @override
  State<AdvertisementDetailPage> createState() =>
      _AdvertisementDetailPageState();
}

class _AdvertisementDetailPageState extends State<AdvertisementDetailPage> {
  final AdvertisementImageRepository _imageRepository =
      AdvertisementImageRepository();
  List<AdvertisementImage> _images = [];
  bool _isLoading = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final images =
          await _imageRepository.getAdvertisementImages(widget.advertisementId);
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock advertisement data - in real app, this would come from the previous screen or API
    final advertisement = Advertisement(
      id: widget.advertisementId,
      title: 'Título do Anúncio',
      description: 'Descrição detalhada do anúncio...',
      price: 150.00,
      status: 'active',
      categoryId: 1,
      userId: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Anúncio'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            SizedBox(
              height: 300,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _images.isEmpty
                      ? Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 100, color: Colors.grey),
                          ),
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              itemCount: _images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.network(
                                  _images[index].url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child:
                                            Icon(Icons.broken_image, size: 100),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            if (_images.length > 1)
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _images.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentImageIndex == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
            ),

            // Advertisement details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  if (advertisement.price != null)
                    Text(
                      'R\$ ${advertisement.price!.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    advertisement.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    advertisement.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Status
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${_getStatusText(advertisement.status)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Created date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Publicado em: ${_formatDate(advertisement.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // Contact seller action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Entrar em contato',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Ativo';
      case 'inactive':
        return 'Inativo';
      case 'banned':
        return 'Banido';
      case 'review':
        return 'Em revisão';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

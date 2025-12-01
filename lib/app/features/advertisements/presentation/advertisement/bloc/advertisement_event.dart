abstract class AdvertisementEvent {}

class LoadAdvertisementsByCategory extends AdvertisementEvent {
  final int categoryId;

  LoadAdvertisementsByCategory(this.categoryId);
}

class CreateAdvertisement extends AdvertisementEvent {
  final String title;
  final String description;
  final double? price;
  final int categoryId;

  CreateAdvertisement({
    required this.title,
    required this.description,
    this.price,
    required this.categoryId,
  });
}

class UpdateAdvertisementStatus extends AdvertisementEvent {
  final int id;
  final String status;

  UpdateAdvertisementStatus({required this.id, required this.status});
}

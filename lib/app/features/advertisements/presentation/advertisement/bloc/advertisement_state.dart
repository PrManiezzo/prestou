import 'package:prestou/app/features/advertisements/data/models/advertisement.dart';

abstract class AdvertisementState {}

class AdvertisementInitial extends AdvertisementState {}

class AdvertisementLoading extends AdvertisementState {}

class AdvertisementLoaded extends AdvertisementState {
  final List<Advertisement> advertisements;

  AdvertisementLoaded(this.advertisements);
}

class AdvertisementCreated extends AdvertisementState {
  final Advertisement advertisement;

  AdvertisementCreated(this.advertisement);
}

class AdvertisementError extends AdvertisementState {
  final String message;

  AdvertisementError(this.message);
}

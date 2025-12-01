import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestou/app/features/advertisements/data/repositories/advertisement_repository.dart';
import 'advertisement_event.dart';
import 'advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  final AdvertisementRepository _repository = AdvertisementRepository();

  AdvertisementBloc() : super(AdvertisementInitial()) {
    on<LoadAdvertisementsByCategory>(_onLoadAdvertisementsByCategory);
    on<CreateAdvertisement>(_onCreateAdvertisement);
    on<UpdateAdvertisementStatus>(_onUpdateAdvertisementStatus);
  }

  Future<void> _onLoadAdvertisementsByCategory(
    LoadAdvertisementsByCategory event,
    Emitter<AdvertisementState> emit,
  ) async {
    emit(AdvertisementLoading());
    try {
      final advertisements =
          await _repository.getAdvertisementsByCategory(event.categoryId);
      emit(AdvertisementLoaded(advertisements));
    } catch (e) {
      emit(AdvertisementError(e.toString()));
    }
  }

  Future<void> _onCreateAdvertisement(
    CreateAdvertisement event,
    Emitter<AdvertisementState> emit,
  ) async {
    emit(AdvertisementLoading());
    try {
      final advertisement = await _repository.createAdvertisement(
        title: event.title,
        description: event.description,
        price: event.price,
        categoryId: event.categoryId,
      );
      emit(AdvertisementCreated(advertisement));
    } catch (e) {
      emit(AdvertisementError(e.toString()));
    }
  }

  Future<void> _onUpdateAdvertisementStatus(
    UpdateAdvertisementStatus event,
    Emitter<AdvertisementState> emit,
  ) async {
    try {
      await _repository.updateAdvertisementStatus(
        id: event.id,
        status: event.status,
      );
      // Reload advertisements if needed
    } catch (e) {
      emit(AdvertisementError(e.toString()));
    }
  }
}

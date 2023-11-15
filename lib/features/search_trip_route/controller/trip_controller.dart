import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/search_trip_route/repository/trip_repository.dart';

import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/find_trip_model.dart';

final tripControllerProvider = StateNotifierProvider<TripController, bool>(
  (ref) => TripController(
    tripRepository: ref.watch(tripRepositoryProvider),
  ),
);

class TripController extends StateNotifier<bool> {
  final TripRepository _tripRepository;
  TripController({
    required tripRepository,
  })  : _tripRepository = tripRepository,
        super(false);

  Future<bool> findDriver(BuildContext context, FindTripModel tripModel) async {
    final endAddress = await placemarkFromCoordinates(
      tripModel.endLatitude,
      tripModel.endLongitude,
    );
    final startAddress = await placemarkFromCoordinates(
      tripModel.startLatitude,
      tripModel.startLongitude,
    );
    tripModel.copyWith(
      endAddress: endAddress.first.name,
      startAddress: startAddress.first.name,
    );
    final result = await _tripRepository.findDriver(tripModel);
    result.fold((l) {
      state = false;
      showSnackBar(
        context: context,
        message: l.message,
      );
    }, (r) {
      state = r;
    });
    return state;
  }

  Future<List<CarModel>> getCarDetails(
    BuildContext context,
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    print('Car details controller');
    List<CarModel> list = [];
    final result = await _tripRepository.getCarDetails(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    result.fold((l) {
      showSnackBar(
        context: context,
        message: l.message,
      );
    }, (r) {
      print(r.length.toString());
      list = r;
    });
    return list;
  }
}

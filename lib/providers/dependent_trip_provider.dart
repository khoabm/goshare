import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/models/trip_model.dart';

final tripProvider = StateNotifierProvider<TripNotifier, TripModel?>((ref) {
  return TripNotifier();
});

class TripNotifier extends StateNotifier<TripModel?> {
  TripNotifier() : super(null);
  TripModel? get tripData => state;
  void setTripData(Map<String, dynamic> tripData) {
    state = TripModel.fromMap(tripData);
  }

  void setTripDataWithModel(TripModel? tripdata) {
    state = tripdata;
  }
}

final driverProvider = StateNotifierProvider<DriverNotifier, Driver?>((ref) {
  return DriverNotifier();
});

class DriverNotifier extends StateNotifier<Driver?> {
  DriverNotifier() : super(null);

  Driver? get driverData => state;

  void addDriverData(Driver driver) {
    state = driver;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/models/location_model.dart';

class UserLocationNotifier extends StateNotifier<List<LocationModel>> {
  UserLocationNotifier() : super([]);

  void loadLocations(List<LocationModel> newLocations) {
    state = newLocations;
  }

  void addLocation(LocationModel newLocation) {
    state = [...state, newLocation];
  }
}

final userLocationProvider = StateNotifierProvider.autoDispose<
    UserLocationNotifier, List<LocationModel>>((ref) => UserLocationNotifier());

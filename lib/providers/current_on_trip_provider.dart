import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/models/user_data_model.dart';

final currentOnTripIdProvider =
    StateNotifierProvider<CurrentOnTripIdNotifier, String?>(
        (ref) => CurrentOnTripIdNotifier());

class CurrentOnTripIdNotifier extends StateNotifier<String?> {
  CurrentOnTripIdNotifier() : super(null);
  String? get currentTripId => state;
  void setCurrentOnTripId(String? id) {
    state = id;
  }
}

final currentDependentOnTripProvider = StateNotifierProvider<
    CurrentDependentOnTripIdNotifier,
    List<DependentTrip>>((ref) => CurrentDependentOnTripIdNotifier());

class CurrentDependentOnTripIdNotifier
    extends StateNotifier<List<DependentTrip>> {
  CurrentDependentOnTripIdNotifier() : super([]);
  List<DependentTrip> get currentTripId => state;
  void setDependentCurrentOnTripId(List<DependentTrip> trips) {
    state = trips;
  }

  void addDependentCurrentOnTripId(DependentTrip trip) {
    state = [...state, trip];
  }

  void removeDependentCurrentOnTripId(String tripId) {
    state = state.where((element) => element.id == tripId).toList();
  }
}

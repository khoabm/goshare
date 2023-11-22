import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentOnTripIdProvider =
    StateNotifierProvider<CurrentOnTripIdNotifier, String?>(
        (ref) => CurrentOnTripIdNotifier());

class CurrentOnTripIdNotifier extends StateNotifier<String?> {
  CurrentOnTripIdNotifier() : super(null);

  void setCurrentOnTripId(String? id) {
    state = id;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/dependent_mng/dependent_mng_repository.dart';
import 'package:goshare/features/trip_history/trip_history_repository.dart';
import 'package:goshare/models/trip_model.dart';

final TripHistoryControllerProvider =
    StateNotifierProvider<TripHistoryController, bool>(
  (ref) => TripHistoryController(
    tripHistoryRepository: ref.watch(tripHistoryRepositoryProvider),
  ),
);

class TripHistoryController extends StateNotifier<bool> {
  final TripHistoryRepository _tripHistoryRepository;
  TripHistoryController({
    required TripHistoryRepository tripHistoryRepository,
  })  : _tripHistoryRepository = tripHistoryRepository,
        super(false);

  Future<List<TripModel>> tripHistory(
    BuildContext context,
  ) async {
    final result = await _tripHistoryRepository.getTripHistory();
    List<TripModel> res = [];
    result.fold(
      (l) {
        showSnackBar(
          context: context,
          message: l.message,
        );
      },
      (success) {
        res = success;
      },
    );
    return res;
  }
}

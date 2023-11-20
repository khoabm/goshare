import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/dependent_list/repository/dependent_repository.dart';

import 'package:goshare/models/dependent_model.dart';

final dependentControllerProvider =
    StateNotifierProvider<DependentController, bool>(
  (ref) => DependentController(
    dependentRepository: ref.watch(dependentRepositoryProvider),
  ),
);

class DependentController extends StateNotifier<bool> {
  final DependentRepository _dependentRepository;
  DependentController({
    required dependentRepository,
  })  : _dependentRepository = dependentRepository,
        super(false);

  Future<DependentListResponseModel?> getDependents(
    BuildContext context,
    String? sortBy,
    int page,
    int pageSize,
  ) async {
    DependentListResponseModel? dependentList;
    final result = await _dependentRepository.getDependents(
      sortBy ?? '',
      page: page,
      pageSize: pageSize,
    );
    result.fold((l) {
      state = false;
      showSnackBar(
        context: context,
        message: l.message,
      );
    }, (r) {
      dependentList = r;
    });
    return dependentList;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/dependent_mng/dependent_mng_repository.dart';

final DependentAddControllerProvider =
    StateNotifierProvider<DependentAddController, bool>(
  (ref) => DependentAddController(
    dependentMngRepository: ref.watch(dependentMngRepositoryProvider),
  ),
);

class DependentAddController extends StateNotifier<bool> {
  final DependentMngRepository _dependentMngRepository;
  DependentAddController({
    required DependentMngRepository dependentMngRepository,
  })  : _dependentMngRepository = dependentMngRepository,
        super(false);
  Future dependentAdd(
    String phone,
    String name,
    String gender,
    DateTime birth,
    BuildContext context,
  ) async {
    final result =
        await _dependentMngRepository.addDependent(phone, name, gender, birth);
    result.fold(
      (l) {
        state = false;
        showErrorDialog2(
          context,
          l.message,
        );
      },
      (success) {
        state = success;
      },
    );
    return state;
  }
}

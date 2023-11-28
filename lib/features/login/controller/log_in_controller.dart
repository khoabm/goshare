import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/utils/utils.dart';

import 'package:goshare/features/login/repository/log_in_repository.dart';

final LoginControllerProvider = StateNotifierProvider<LoginController, bool>(
  (ref) => LoginController(
    loginRepository: ref.watch(loginRepositoryProvider),
  ),
);

class LoginController extends StateNotifier<bool> {
  final LoginRepository _loginRepository;
  LoginController({
    required LoginRepository loginRepository,
  })  : _loginRepository = loginRepository,
        super(false);
  Future<LoginResult> login(
    String phone,
    String passcode,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final result = await _loginRepository.login(phone, passcode, ref);
    return result;
  }

  Future<bool> updateFcmToken() async {
    final result = await _loginRepository.updateFcmToken();
    result.fold(
      (l) {},
      (success) {
        state = success;
      },
    );
    return state;
  }

  Future<String> getUserData(BuildContext context, WidgetRef ref) async {
    final result = await _loginRepository.getUserData(ref);
    String data = '';
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      print(r);
      data = r;
    });
    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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
  Future<String> login(
    String phone,
    String passcode,
    BuildContext context,
  ) async {
    final result = await _loginRepository.login(phone, passcode);
    return result;
  }
}

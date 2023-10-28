import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/utils.dart';
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
        super(false); //loading is false

  Future<String> login(
    String phone,
    String passcode,
    BuildContext context,
  ) async {
    final result = await _loginRepository.login(phone, passcode);

    return result;

    // result.fold(
    //   (l) {
    //     state = false;
    //     showSnackBar(
    //       context: context,
    //       message: l.message,
    //     );
    //   },
    //   (success) {
    //     state = success;
    //   },
    // );
    // return state;
  }

  // Future<String?> sendOtpVerification(
  //   String phone,
  //   String otp,
  //   BuildContext context,
  // ) async {
  //   String? setToken;
  //   final result = await _signUpRepository.sendOtpVerification(
  //     phone,
  //     otp,
  //   );
  //   result.fold(
  //     (l) {
  //       showSnackBar(
  //         context: context,
  //         message: l.message,
  //       );
  //     },
  //     (success) {
  //       setToken = success;
  //     },
  //   );
  //   return setToken;
  // }

  // Future<bool> setPasscode(
  //   String phone,
  //   String setToken,
  //   String passcode,
  //   BuildContext context,
  // ) async {
  //   final result = await _signUpRepository.setPasscode(
  //     phone,
  //     passcode,
  //     setToken,
  //   );
  //   result.fold(
  //     (l) {
  //       state = false;
  //       showSnackBar(
  //         context: context,
  //         message: l.message,
  //       );
  //     },
  //     (success) {
  //       state = success;
  //     },
  //   );
  //   return state;
  // }
}

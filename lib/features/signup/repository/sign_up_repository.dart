import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:http/http.dart' as http;

final signUpRepositoryProvider = Provider(
  (ref) => SignUpRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class SignUpRepository {
  final String baseUrl;

  SignUpRepository({required this.baseUrl});

  ///**
  ///Register new user with given information
  ///
  /// */
  FutureEither<bool> registerUser(
    String name,
    String phone,
    int gender,
    DateTime birth,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'phone': convertPhoneNumber(phone),
          'gender': 1,
          'birth': birth.toIso8601String(),
        }),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  ///**
  ///Send otp verification code to server
  ///
  /// */
  FutureEither<String?> sendOtpVerification(
    String phone,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone': convertPhoneNumber(phone),
          'otp': otp,
        }),
      );
      if (response.statusCode == 200) {
        return right(
          response.body.toString(),
        );
      } else {
        return left(
          Failure('Gửi otp thất bại'),
        );
      }
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEither<bool> setPasscode(
      String phone, String passcode, String setToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/set-passcode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone': convertPhoneNumber(phone),
          'passcode': passcode,
          'setToken': setToken,
        }),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEither<bool> reSendOtpVerification(
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resendotp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone': convertPhoneNumber(phone),
        }),
      );
      if (response.statusCode == 200) {
        return right(
          true,
        );
      } else {
        return left(
          Failure('Gửi otp thất bại'),
        );
      }
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}

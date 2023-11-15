import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:http/http.dart' as http;

final loginRepositoryProvider = Provider(
  (ref) => LoginRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class LoginRepository {
  final String baseUrl;

  LoginRepository({required this.baseUrl});

  Future<String> login(
    String phone,
    String passcode,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phone': convertPhoneNumber(phone),
          'passcode': passcode,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'cannot login';
      }
    } catch (e) {
      return 'uuu';
    }
  }
}

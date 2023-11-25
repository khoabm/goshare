import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/user_data_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final moneyTopupRepositoryProvider = Provider(
  (ref) => MoneyTopupRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

// class LoginResult {
//   final String? accessToken;
//   final String? refreshToken;
//   final User? user;
//   final String? error;

//   LoginResult({this.accessToken, this.refreshToken, this.user, this.error});
// }

class MoneyTopupRepository {
  final String baseUrl;

  MoneyTopupRepository({required this.baseUrl});

  Future<String> moneyTopup(int amount) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.post(
        Uri.parse('$baseUrl/payment/topup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'amount': amount, 'method': 0}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // return LoginResult(error: 'Login failed');
        return "Top up fail";
      }
    } catch (e) {
      return "Top up fail";
      // return LoginResult(error: 'An error occurred while topup money');
    }
  }
}

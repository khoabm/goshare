import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  FutureEither<bool> updateFcmToken() async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      // Get FCM token
      String? fcmToken = await firebaseMessaging.getToken();

      if (fcmToken == null) {
        return left(Failure('"Failed to get FCM token"'));
      }

      // Make HTTP request
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.put(
        Uri.parse('${Constants.apiBaseUrl}/user/update-fcm'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(Failure('"Failed to get FCM token"'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'AccessToken': accessToken,
          'RefreshToken': 'igXW9entARDS9NH5Gm98TPi/kozmL018ItItFIKOAfw=',
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return right(jsonData['accessToken']);
      } else {
        return left(UnauthorizedFailure('Fail to renew token'));
      }
    } catch (e) {
      return left(UnauthorizedFailure('Fail to renew token'));
    }
  }
}

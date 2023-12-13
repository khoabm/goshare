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

final loginRepositoryProvider = Provider(
  (ref) => LoginRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class LoginResult {
  final String? accessToken;
  final String? refreshToken;
  final User? user;
  final String? error;

  LoginResult({this.accessToken, this.refreshToken, this.user, this.error});
}

class LoginRepository {
  final String baseUrl;

  LoginRepository({required this.baseUrl});

  Future<LoginResult> login(
      String phone, String passcode, WidgetRef ref) async {
    // if (phone.isEmpty || passcode.isEmpty) {
    //   phone = '+84363111098';
    //   passcode = '123456';
    // }

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
        final resultMap = json.decode(response.body);
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final userData = UserDataModel.fromMap(jsonData);
        ref
            .watch(currentOnTripIdProvider.notifier)
            .setCurrentOnTripId(userData.currentTrip);
        ref
            .watch(currentDependentOnTripProvider.notifier)
            .setDependentCurrentOnTripId(userData.dependentCurrentTrips ?? []);
        return LoginResult(
          accessToken: resultMap['accessToken'],
          refreshToken: resultMap['refreshToken'],
          user: User(
            id: resultMap['id'],
            phone: resultMap['phone'],
            name: resultMap['name'],
            role: resultMap['role'],
          ),
        );
      } else {
        return LoginResult(error: 'Login failed');
      }
    } catch (e) {
      return LoginResult(error: 'An error occurred');
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

  FutureEither<bool> removeFcmToken() async {
    try {
      // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      // // Get FCM token
      // String? fcmToken = await firebaseMessaging.getToken();

      // if (fcmToken == null) {
      //   return left(Failure('"Failed to get FCM token"'));
      // }

      // Make HTTP request
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.put(
        Uri.parse('${Constants.apiBaseUrl}/user/update-fcm'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'fcmToken': null,
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

  FutureEither<String> getUserData(WidgetRef ref) async {
    try {
      print('get user data');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final refreshToken = prefs.getString('refreshToken');

      final response = await http
          .post(
            Uri.parse('${Constants.apiBaseUrl}/auth/refresh-token'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'AccessToken': accessToken,
              'RefreshToken': refreshToken,
            }),
          )
          .timeout(
            const Duration(
              seconds: 120,
            ),
          );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final userData = UserDataModel.fromMap(jsonData);
        print('get user dâta');
        if (jsonData.containsKey('id') &&
            jsonData.containsKey('phone') &&
            jsonData.containsKey('name') &&
            jsonData.containsKey('role')) {
          User userTmp = User(
            id: jsonData['id'],
            phone: jsonData['phone'],
            name: jsonData['name'],
            role: jsonData['role'],
          );
          ref.read(userProvider.notifier).state = userTmp;

          ref
              .watch(currentOnTripIdProvider.notifier)
              .setCurrentOnTripId(userData.currentTrip);
          ref
              .watch(currentDependentOnTripProvider.notifier)
              .setDependentCurrentOnTripId(
                  userData.dependentCurrentTrips ?? []);
        }
        return right(jsonData['accessToken']);
      } else {
        return left(UnauthorizedFailure('Fail to renew token'));
      }
    } on TimeoutException {
      return left(Failure(''));
    } catch (e) {
      return left(UnauthorizedFailure('Fail to renew token'));
    }
  }
}

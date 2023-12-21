import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependentMngRepositoryProvider = Provider(
  (ref) => DependentMngRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class DependentMngRepository {
  final String baseUrl;

  DependentMngRepository({required this.baseUrl});

  FutureEither<bool> addDependent(
      String phone, String name, String gender, DateTime birth) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');

      final res = await client.post(
        Uri.parse('$baseUrl/user/dependent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone": convertPhoneNumber(phone),
          "name": name,
          "gender": gender == 'Nam' ? 1 : 0,
          "birth": birth.toString().substring(0, 10),
        }),
      );
      if (res.statusCode == 200) {
        return right(true);
      } else if (res.statusCode == 400) {
        final response = json.decode(res.body);
        if (response['message'] == 'Phone number existed') {
          return left(
            Failure(
              'Số điện thoại đã tồn tại',
            ),
          );
        } else {
          return left(
            Failure(
              response['message'],
            ),
          );
        }
      } else {
        final response = json.decode(res.body);
        return left(
          Failure(
            response['message'],
          ),
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

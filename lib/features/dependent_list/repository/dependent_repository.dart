import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/models/dependent_location_model.dart';
import 'package:goshare/models/dependent_model.dart';

import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependentRepositoryProvider = Provider((ref) {
  return DependentRepository(
    baseApiUrl: Constants.apiBaseUrl,
  );
});

class DependentRepository {
  final String baseApiUrl;

  DependentRepository({
    required this.baseApiUrl,
  });

  FutureEither<DependentListResponseModel> getDependents(
    String sortBy, {
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.get(
        Uri.parse(
            '$baseApiUrl/user/dependents?sortBy=$sortBy&page=$page&pageSize=$pageSize'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final item = DependentListResponseModel.fromJson(res.body);

        return right(item);
      } else if (res.statusCode == 429) {
        return left(
          Failure('Too many request'),
        );
      } else {
        return left(
          Failure('Co loi xay ra'),
        );
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  FutureEither<LocationModel> createDestination(
    double latitude,
    double longitude,
    String address,
    String name,
    String? userId,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.post(
        Uri.parse('$baseApiUrl/location'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
          "address": address,
          "name": name,
          "userId": userId,
        }),
      );
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        final data = LocationModel.fromJson(res.body);
        return right(data);
      } else if (res.statusCode == 429) {
        return left(
          Failure('Too many request'),
        );
      } else {
        return left(
          Failure('Co loi xay ra'),
        );
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  FutureEither<DependentLocationModel> getDependentLocation({
    required String dependentId,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.post(
        Uri.parse('$baseApiUrl/location/$dependentId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {'dependentId': dependentId},
        ),
      );
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        final item = DependentLocationModel.fromJson(res.body);
        // final item = res.body;

        return right(item);
      } else if (res.statusCode == 429) {
        return left(
          Failure('Too many request'),
        );
      } else {
        return left(
          Failure('Có lỗi! Không lấy được vị trí người thân'),
        );
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }
}

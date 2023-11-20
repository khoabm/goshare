import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/models/dependent_model.dart';

import 'package:goshare/core/constants/constants.dart';
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
}

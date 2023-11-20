import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/models/dependent_model.dart';

import 'package:http/http.dart' as http;

import 'package:goshare/core/constants/constants.dart';

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
      print('REPO NEEEEE');
      final res = await http.get(
        Uri.parse(
            '$baseApiUrl/user/dependents?sortBy=$sortBy&page=$page&pageSize=$pageSize'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJpZCI6IjUzMmQ3M2NhLWFjNWQtNDczMi1hNDhiLTc1MDUwMmQxOWMzNyIsInBob25lIjoiODQ5MzM2ODQ5MDkiLCJuYW1lIjoiVGhvIE5ndXllbiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3MDA0MTQ5NDcsImlzcyI6Imp3dCIsImF1ZCI6Imp3dCJ9.6DQIIH2wVCqjQ3qswUiNJkulFb9TiAY4MQ_Rt91-mEA',
          'Content-Type': 'application/json',
        },
      );
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        final item = DependentListResponseModel.fromJson(res.body);

        // final jsonData = json.decode(
        //   res.body,
        // );

        // final DependentListResponseModel places =
        //     jsonData.map((json) => DependentListResponseModel.fromMap(json));

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

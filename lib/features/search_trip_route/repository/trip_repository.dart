import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:http/http.dart' as http;

final tripRepositoryProvider = Provider(
  (ref) => TripRepository(
    baseApiUrl: Constants.apiBaseUrl,
  ),
);

class TripRepository {
  final String baseApiUrl;

  TripRepository({
    required this.baseApiUrl,
  });

  // FutureEither<List<String>?> searchPlaces(String prompt, String format, String countryCodes){
  //   try {

  //   } catch (e) {

  //   }
  // }
  FutureEither<List<CarModel>> getCarDetails(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    List<CarModel> list = [];
    try {
      print(startLatitude);
      final res = await http.post(
        Uri.parse('$baseApiUrl/trip/fees'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJpZCI6IjUzMmQ3M2NhLWFjNWQtNDczMi1hNDhiLTc1MDUwMmQxOWMzNyIsInBob25lIjoiODQ5MzM2ODQ5MDkiLCJuYW1lIjoiVGhvIE5ndXllbiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3MDAwNDYyMDQsImlzcyI6Imp3dCIsImF1ZCI6Imp3dCJ9.ArrTx64t2b4Uqu3NEIP6jGln_fSJ76r66tA7D6-vYWs',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'startLatitude': startLatitude,
          'startLongitude': startLongitude,
          'endLatitude': endLatitude,
          'endLongitude': endLongitude,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          res.body,
        );

        list = jsonData.map((json) => CarModel.fromMap(json)).toList();
        return right(list);
      } else if (res.statusCode == 429) {
        return left(
          Failure('Too many request'),
        );
      } else {
        return left(
          Failure('Co loi xay ra'),
        );
      }
    } catch (e) {
      print(e.toString());
      return left(
        Failure('Loi roi'),
      );
    }
  }

  FutureEither<bool> findDriver(FindTripModel tripModel) async {
    print('Trong REPO NEEEEEEEEEEEEEEEEEEEEEEE');
    try {
      // Map<String, dynamic> tripModelMap = tripModel.toMap();
      String tripModelJson = tripModel.toJson();

      final response = await http.post(
        Uri.parse('$baseApiUrl/trip'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJpZCI6IjUzMmQ3M2NhLWFjNWQtNDczMi1hNDhiLTc1MDUwMmQxOWMzNyIsInBob25lIjoiODQ5MzM2ODQ5MDkiLCJuYW1lIjoiVGhvIE5ndXllbiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3MDAwNDYyMDQsImlzcyI6Imp3dCIsImF1ZCI6Imp3dCJ9.ArrTx64t2b4Uqu3NEIP6jGln_fSJ76r66tA7D6-vYWs',
          'Content-Type': 'application/json',
        },
        body: tripModelJson,
      );

      print(response.statusCode);
      print(response.body);
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

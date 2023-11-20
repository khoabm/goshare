import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Either<Failure, List<CarModel>>> getCarDetails(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    List<CarModel> list = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.post(
        Uri.parse('$baseApiUrl/trip/fees'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'startLatitude': startLatitude,
          'startLongitude': startLongitude,
          'endLatitude': endLatitude,
          'endLongitude': endLongitude,
        }),
      );

      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(res.body);
        list = jsonData.map((json) => CarModel.fromMap(json)).toList();
        return right(list);
      } else if (res.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (res.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } catch (e) {
      print(e.toString());
      return left(Failure('Loi roi'));
    }
  }

  FutureEither<String> findDriver(FindTripModel tripModel) async {
    try {
      // Map<String, dynamic> tripModelMap = tripModel.toMap();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      String tripModelJson = tripModel.toJson();
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.post(
        Uri.parse('$baseApiUrl/trip'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: tripModelJson,
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return right(jsonData['id']);
      } else if (response.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (response.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> cancelTrip(String tripId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.post(
        Uri.parse('$baseApiUrl/trip/cancel/$tripId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tripId': tripId,
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          return right(true);
        } else {
          return right(false);
        }
      } else if (res.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
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
}

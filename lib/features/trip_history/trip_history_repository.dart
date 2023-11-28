import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tripHistoryRepositoryProvider = Provider(
  (ref) => TripHistoryRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class TripHistoryRepository {
  final String baseUrl;

  TripHistoryRepository({required this.baseUrl});

  Future<Either<Failure, List<TripModel>>> getTripHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');

      final res = await client.get(
        Uri.parse('$baseUrl/trip/history'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final dynamic responseData = jsonDecode(res.body);

        if (responseData == null || responseData is! List) {
          throw Exception('Unexpected response format');
        }

        final List<dynamic> data = responseData;
      
        final List<TripModel> trips = List<Map<String, dynamic>>.from(data)
            .map((tripData) => TripModel.fromMap(tripData))
            .toList();
        return right(trips);
      } else {
        throw Exception('Failed to load trip history');
      }
    } catch (error) {
      throw Exception('Failed to load trip history: $error');
    }
  }
}

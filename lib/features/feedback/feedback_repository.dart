import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

final feedbackRepositoryProvider = Provider(
  (ref) => FeedbackRepository(
    baseUrl: Constants.apiBaseUrl,
  ),
);

class RatingResult {
  final String? id;
  final String? rater;
  final String? ratee;
  final String? tripId;
  final int? rating;
  final String? comment;
  final String? createTime;
  final String? updatedTime;
  final String? error;

  RatingResult(
      {this.id,
      this.rater,
      this.ratee,
      this.tripId,
      this.rating,
      this.comment,
      this.createTime,
      this.updatedTime,
      this.error});
}

class FeedbackRepository {
  final String baseUrl;

  FeedbackRepository({required this.baseUrl});

  Future<RatingResult> feedback(
      String idTrip, int rating, String content) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      // final id = 10;

      final response = await client.post(
        Uri.parse('$baseUrl/trip/rate-driver/$idTrip'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"rating": rating, "comment": content}),
      );

      print("feedbackres" + response.body);

      if (response.statusCode == 200) {
        return RatingResult(
          id: jsonDecode(response.body)['id'],
          rater: jsonDecode(response.body)['rater'],
          ratee: jsonDecode(response.body)['ratee'],
          tripId: jsonDecode(response.body)['tripId'],
          rating: jsonDecode(response.body)['rating'],
          comment: jsonDecode(response.body)['comment'],
          createTime: jsonDecode(response.body)['createTime'],
          updatedTime: jsonDecode(response.body)['updatedTime'],
        );
      } else {
        return RatingResult(error: 'Login failed');
        // return LoginResult(error: 'Login failed');
        // return "Feedback fail";
      }
    } catch (e) {
      return RatingResult(error: 'Login failed');
      // return LoginResult(error: 'An error occurred while topup money');
    }
  }
}

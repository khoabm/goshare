import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:goshare/models/trip_model.dart';
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

  FutureEither<TripModel> findDriver(FindTripModel tripModel) async {
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
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> tripData = json.decode(response.body);
        TripModel trip = TripModel.fromMap(tripData);
        return right(trip);
      } else if (response.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (response.statusCode == 401) {
        return left(
          UnauthorizedFailure('Unauthorized'),
        );
      } else if (response.statusCode == 400) {
        Map<String, dynamic> error = json.decode(response.body);
        if (error['message'] ==
            "Passenger is already in a trip that hasn't completed. Please complete the current trip before creating a new one.") {
          return left(AlreadyInTripFailure(
              'Bạn không thể tạo chuyến vào lúc này. Nếu đây là lỗi vui lòng liên hệ cho hệ thống'));
        } else if (error['message'] ==
            "You are not allow to create trip at the moment.") {
          return left(AlreadyInTripFailure(
              'Bạn không thể tạo chuyến vào lúc này. Nếu đây là lỗi vui lòng liên hệ cho hệ thống'));
        } else {
          left(
            AlreadyInTripFailure(
                'Bạn không thể tạo chuyến vào lúc này. Nếu đây là lỗi vui lòng liên hệ cho hệ thống'),
          );
        }
        return left(
          Failure('Có lỗi xảy ra'),
        );
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } catch (e) {
      print(e.toString());
      return left(Failure(e.toString()));
    }
  }

  FutureEither<TripModel> findDriverForDependent(
    FindTripModel tripModel,
    String dependentId,
  ) async {
    try {
      // Map<String, dynamic> tripModelMap = tripModel.toMap();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      //String tripModelJson = tripModel.toJson();
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.post(
        Uri.parse('$baseApiUrl/trip/$dependentId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "endLatitude": tripModel.endLatitude,
          "endLongitude": tripModel.endLongitude,
          "endAddress": tripModel.endAddress,
          "cartypeId": tripModel.cartypeId,
          "paymentMethod": tripModel.paymentMethod,
          "note": tripModel.note,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> tripData = json.decode(response.body);
        TripModel trip = TripModel.fromMap(tripData);
        return right(trip);
      } else if (response.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (response.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } catch (e) {
      print(e.toString());
      return left(Failure(e.toString()));
    }
  }

  FutureEither<TripModel> getTripInfo(
    String tripId,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final response = await client.get(
        Uri.parse('$baseApiUrl/trip/$tripId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> tripData = json.decode(response.body);
        TripModel trip = TripModel.fromMap(tripData);
        return right(trip);
      } else if (response.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (response.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } catch (e) {
      print(e.toString());
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

  FutureEither<bool> sendChat(
    String content,
    String receiver,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.post(
        Uri.parse('$baseApiUrl/chat/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "receiver": receiver,
          "content": content,
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

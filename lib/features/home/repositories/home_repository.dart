import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:goshare/models/location_model.dart';
import 'package:goshare/models/user_profile_model.dart';
import 'package:goshare/models/vietmap_autocomplete_model.dart';
import 'package:http/http.dart' as http;

import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/models/search_places_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository(
    baseApiUrl: Constants.apiBaseUrl,
    searchApiUrl: Constants.searchPlacesApiUrl,
  );
});

class HomeRepository {
  final String baseApiUrl;
  final String searchApiUrl;
  HomeRepository({
    required this.baseApiUrl,
    required this.searchApiUrl,
  });

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buổi sáng tốt lành';
    } else if (hour < 17) {
      return 'Buổi trưa vui vẻ';
    }
    return 'Buổi tối tốt lành';
  }

  FutureEither<List<VietmapAutocompleteModel>> searchLocation(
      String keySearch) async {
    try {
      print('hehe');
      final queryParameters = {
        'apikey': Constants.vietMapApiKey,
        'text': keySearch,
      };
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      );
      final uri = Uri.https(
        'maps.vietmap.vn',
        '/api/autocomplete/v3',
        queryParameters,
      );

      var res = await http.get(uri);

      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          res.body,
        );

        final List<VietmapAutocompleteModel> places = jsonData
            .map((json) => VietmapAutocompleteModel.fromMap(json))
            .toList();

        return right(places);
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

  FutureEither<VietmapAutocompleteModel> searchLocationReverse(
    double lat,
    double lng,
  ) async {
    try {
      final queryParameters = {
        'apikey': Constants.vietMapApiKey,
        'lng': lng.toString(),
        'lat': lat.toString(),
      };
      await Future.delayed(
        const Duration(
          seconds: 1,
        ),
      );
      final uri = Uri.https(
        'maps.vietmap.vn',
        '/api/reverse/v3',
        queryParameters,
      );
      print(uri.toString());

      var res = await http.get(uri);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          res.body,
        );
        final List<VietmapAutocompleteModel> places = jsonData
            .map((json) => VietmapAutocompleteModel.fromMap(json))
            .toList();
        final place = places.first;
        return right(place);
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

  FutureEither<List<LocationModel>> getUserListLocation() async {
    List<LocationModel> list = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.get(
        Uri.parse('$baseApiUrl/location'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(res.body);
        print(jsonData);
        list = jsonData.map((json) => LocationModel.fromMap(json)).toList();
        return right(list);
      } else if (res.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (res.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  FutureEither<UserProfileModel> getUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.get(
        Uri.parse('$baseApiUrl/user/profile'),
        headers: {
          //'Content-Type': 'application/json',
          "Cache-Control": "no-cache"
        },
      );
      print(res.request.toString());
      print(res.request?.headers.toString());
      if (res.statusCode == 200) {
        Map<String, dynamic> userProfileData = json.decode(res.body);
        UserProfileModel userProfile =
            UserProfileModel.fromMap(userProfileData);
        print(userProfileData.toString());
        return right(userProfile);
      } else if (res.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (res.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  FutureEither<UserProfileModel> getGuardianProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      final client = HttpClientWithAuth(accessToken ?? '');
      final res = await client.get(
        Uri.parse('$baseApiUrl/user/guardian-info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        print("Get guardian info success");
        Map<String, dynamic> userProfileData = json.decode(res.body);
        UserProfileModel userProfile =
            UserProfileModel.fromMap(userProfileData);
        return right(userProfile);
      } else if (res.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (res.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else {
        return left(Failure('Co loi xay ra'));
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  FutureEither<UserProfileModel> editUserProfile(
    String name,
    String? imagePath,
    int gender,
    DateTime birth,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // final client = HttpClientWithAuth(accessToken ?? '');
      // final res = await client.put(
      //   Uri.parse('$baseApiUrl/user/profile'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );
      print(birth.toIso8601String());
      var uri = Uri.parse('$baseApiUrl/user/profile');
      var request = http.MultipartRequest('Put', uri)
        ..fields['name'] = name
        ..fields['gender'] = gender.toString()
        ..fields['birth'] = birth.toIso8601String();
      if (imagePath != null) {
        // Read the file as bytes
        var fileBytes = await File(imagePath).readAsBytes();

        // Add the image file to the multipart request
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            fileBytes,
            filename: 'image', // Provide a filename for the image
          ),
        );
      }
      request.headers.addAll(<String, String>{
        'Authorization': 'Bearer $accessToken',
      });
      var response = await request.send();
      String responseData = await response.stream.bytesToString();
      print(responseData);
      if (response.statusCode == 200) {
        Map<String, dynamic> userProfileData = json.decode(responseData);
        UserProfileModel userProfile =
            UserProfileModel.fromMap(userProfileData);
        return right(userProfile);
      } else if (response.statusCode == 429) {
        return left(Failure('Too many request'));
      } else if (response.statusCode == 401) {
        return left(UnauthorizedFailure('Unauthorized'));
      } else if (response.statusCode == 400) {
        Map<String, dynamic> data = json.decode(responseData);
        return left(
          UpdateProfileFailure(
            data['message'],
          ),
        );
      } else {
        return left(Failure('Có lỗi xảy ra'));
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }

  Stream<List<Place>> searchPlaces(
    String query,
    String format,
    String countrycodes,
    String layer,
    int addressdetails,
  ) async* {
    try {
      final queryParameters = {
        'format': format,
        'countrycodes': countrycodes,
        //'layer': layer,
        'q': query,
        //'addressdetails': addressdetails.toString(),
      };
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        queryParameters,
      );

      final response = await http.get(uri).timeout(
            const Duration(seconds: 30),
          );

      if (response.statusCode == 200) {
        // print(response.body.toString());
        final List<dynamic> jsonData = json.decode(
          response.body,
        );
        final List<Place> places =
            jsonData.map((json) => Place.fromMap(json)).toList();
        yield places;
      } else {
        throw Exception('Failed to load places');
      }
    } on TimeoutException {
      throw TimeoutException('time out');
    } catch (_) {}
  }
}

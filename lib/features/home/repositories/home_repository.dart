import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/models/vietmap_autocomplete_model.dart';
import 'package:http/http.dart' as http;

import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/models/search_places_model.dart';

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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/models/vietmap_place_model.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final locationProvider = Provider<LocationUtils>((ref) => LocationUtils());

class LocationUtils {
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    print(serviceEnabled.toString());
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      print('await for services enable');
      if (!serviceEnabled) {
        print('service enable false');
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      print('await for permission granted');
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('permission granted false');
        return null;
      }
    }

    // Get location data if permission is granted
    if (permissionGranted == PermissionStatus.granted) {
      print('get current location');

      //LocationData locationData = await location.getLocation();
      LocationData? locationData = await Future.any([
        location.getLocation(),
        Future.delayed(const Duration(seconds: 5), () => null),
      ]);
      locationData ??= await location.getLocation();
      return locationData;
    }

    return null;
  }

  static FutureEither<VietmapPlaceModel> getPlaceDetail(String placeId) async {
    try {
      final queryParameters = {
        'apikey': Constants.vietMapApiKey,
        'refid': placeId
      };
      final uri = Uri.https(
        'maps.vietmap.vn',
        '/api/place/v3',
        queryParameters,
      );
      print(uri);
      var res = await http.get(uri);
      print(res.body);
      if (res.statusCode == 200) {
        var data = VietmapPlaceModel.fromJson(res.body);
        return right(data);
      } else {
        return left(
          Failure('Có lỗi xảy ra'),
        );
      }
    } on TimeoutException catch (_) {
      return left(
        Failure('Timeout'),
      );
    }
  }
}

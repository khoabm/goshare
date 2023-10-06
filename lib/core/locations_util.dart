import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'dart:async';

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
      LocationData locationData = await location.getLocation();
      return locationData;
    }

    return null;
  }
}

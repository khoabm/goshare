import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

class PersonLocationProvider extends ChangeNotifier {
  final Location _location = Location();
  PermissionStatus? _permissionGranted;
  StreamController<LocationData> currentLocation = StreamController.broadcast();

  PersonLocationProvider() {
    _init();
  }

  _checkPermission() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    });
  }

  _init() {
    _checkPermission();
    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
      interval: 10000,
    );
    currentLocation.addStream(_location.onLocationChanged);
  }
}

final locationProvider = ChangeNotifierProvider<PersonLocationProvider>((ref) {
  return PersonLocationProvider();
});

final locationStreamProvider = StreamProvider.autoDispose<LocationData>(
  (ref) {
    ref.keepAlive();
    final stream = ref.read(locationProvider).currentLocation.stream;

    return stream;
  },
);

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/dependent_trip_provider.dart';
import 'package:goshare/providers/signalr_providers.dart';
import 'package:location/location.dart';
import 'package:signalr_core/signalr_core.dart';

class TripInformationCardWidget extends ConsumerStatefulWidget {
  final int tripStatus;
  const TripInformationCardWidget({super.key, required this.tripStatus});
  @override
  ConsumerState<TripInformationCardWidget> createState() =>
      _TripInformationCardWidgetState();
}

List<String> announcements = [
  'Tài xế của bạn đang trên đường đến',
  'Bắt đầu di chuyển đến điểm chỉ định'
];

class _TripInformationCardWidgetState
    extends ConsumerState<TripInformationCardWidget> {
  // late final Driver? driver;
  TripModel? trip;

  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  LocationData? driverLocation;

  Future<void> _listenLocation() async {
    final hubConnection = await ref.read(
      hubConnectionProvider.future,
    );
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
      interval: 1000,
    );
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((currentLocation) {
      setState(() {
        _error = null;
        print('${currentLocation.latitude} + ${currentLocation.longitude},');
        if (mounted) {
          driverLocation = currentLocation;

          if (hubConnection.state == HubConnectionState.connected) {
            hubConnection.invoke(
              "SendDependentLocation",
              args: [
                jsonEncode({
                  'latitude': currentLocation.latitude,
                  'longitude': currentLocation.longitude
                }),
                trip!.id,
              ],
            ).then(
              (value) {
                print(
                  "Location sent to server - in card: ${currentLocation.latitude} + ${currentLocation.longitude}",
                );
              },
            ).catchError((error) {
              print("Error sending location to server: $error");
            });
          } else {
            print("Connection is not in the 'Connected' state");
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // trip?.driver = ref.watch(driverProvider.notifier).driverData;
    // print(trip?.driver?.toJson());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        trip = ref.watch(tripProvider.notifier).tripData;
        trip?.copyWith(driver: ref.watch(driverProvider.notifier).driverData);
        if (mounted) {
          _listenLocation();
        }
        print("????????????????????????????????????????");
        print(trip.toString());
      });
    });
    // driver = ref.read(driverProvider.notifier).driverData;
  }

  @override
  void dispose() {
    //revokeHub();
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF05204A)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                announcements[widget.tripStatus],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              maxRadius: 100,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  ref.watch(driverProvider.notifier).driverData?.avatarUrl ??
                      trip?.driver?.avatarUrl ??
                      '',
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  width: 100 * 2,
                  height: 100 * 2,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.watch(driverProvider.notifier).driverData?.name ??
                        trip?.driver?.name ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Số điện thoại:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          convertBackPhoneNumber(
                            ref
                                    .watch(driverProvider.notifier)
                                    .driverData
                                    ?.phone ??
                                trip?.driver?.phone ??
                                '',
                          ),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Biển số xe:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          ref
                                  .watch(driverProvider.notifier)
                                  .driverData
                                  ?.car
                                  ?.licensePlate ??
                              trip?.driver?.car?.licensePlate ??
                              '',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Loại xe:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              ref
                                      .watch(driverProvider.notifier)
                                      .driverData
                                      ?.car
                                      ?.make ??
                                  trip?.driver?.car?.make ??
                                  '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              ' - ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              ref
                                      .watch(driverProvider.notifier)
                                      .driverData
                                      ?.car
                                      ?.model ??
                                  trip?.driver?.car?.model ??
                                  '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

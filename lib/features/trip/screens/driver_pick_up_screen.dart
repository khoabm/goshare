import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:location/location.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/providers/signalr_providers.dart';

class DriverPickUpScreen extends ConsumerStatefulWidget {
  final String driverName;
  final String driverPhone;
  final String driverAvatar;
  final String driverPlate;
  final String driverCarType;
  final String driverId;
  final String endLatitude;
  final String endLongitude;
  const DriverPickUpScreen({
    super.key,
    required this.driverName,
    required this.driverPhone,
    required this.driverAvatar,
    required this.driverPlate,
    required this.driverCarType,
    required this.driverId,
    required this.endLatitude,
    required this.endLongitude,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DriverPickUpScreenState();
}

class _DriverPickUpScreenState extends ConsumerState<DriverPickUpScreen> {
  double _containerHeight = 60.0;
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  LocationData? currentLocation;
  bool _isLoading = false;

  // List<LatLng> latLngList = [
  //   const LatLng(10.736657, 106.672240),
  //   const LatLng(10.766543, 106.742378),
  //   const LatLng(10.775818, 106.640497),
  //   const LatLng(10.727416, 106.735597),
  //   const LatLng(10.738653, 106.674236),
  //   const LatLng(10.792765, 106.674143),
  //   // Add more LatLng values here...
  // ];

  @override
  void dispose() {
    //revokeHub();
    _mapController?.dispose();
    super.dispose();
  }

  void revokeHub() async {
    final hubConnection = await ref.read(
      hubConnectionProvider.future,
    );
    hubConnection.off('UpdateDriverLocation');
    hubConnection.off('NotifyPassengerDriverPickup');
  }

  @override
  void initState() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initSignalR(ref);
      final location = ref.read(locationProvider);
      currentLocation = await location.getCurrentLocation();

      setState(() {});
    });
    super.initState();
  }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on('NotifyPassengerDriverPickup', (message) {
        if (mounted) {
          print("${message.toString()} DAY ROI SIGNAL R DAY ROI");
          _handleNotifyPassengerDriverPickUp(message);
        }
      });
      hubConnection.on(
        'UpdateDriverLocation',
        (arguments) {
          if (mounted) {
            print("SIGNAL R DEP TRIP BOOK" + arguments.toString());
            final stringData = arguments?.first as String;
            final data = jsonDecode(stringData) as Map<String, dynamic>;
            updateMarker(
              data['latitude'],
              data['longitude'],
            );
          }
        },
      );
      hubConnection.onclose((exception) async {
        await Future.delayed(
          const Duration(seconds: 3),
          () async {
            if (mounted &&
                hubConnection.state == HubConnectionState.disconnected) {
              await hubConnection.start();
            }
          },
        );
      });
    } catch (e) {
      rethrow;
      //print(e.toString());
    }
  }

  void _handleNotifyPassengerDriverPickUp(dynamic message) {
    if (mounted) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        final data = message as List<dynamic>;
        final tripData = data.cast<Map<String, dynamic>>().first;
        final trip = TripModel.fromMap(tripData);
        bool isSelfBook = data.cast<bool>()[1];
        bool isNotifyToGuardian = data.cast<bool>()[2];
        if (isSelfBook == true) {
          _showDriverInfoDialog(trip);
        } else {
          if (isNotifyToGuardian == true) {
            _showDependentDriverInfoDialog(trip);
          }
        }
      }
    }
  }

  void _showDriverInfoDialog(TripModel trip) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Tài xế ${trip.driver?.name} đã đến',
            ),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Bạn đã đặt xe: ${trip.driver?.car.make} ${trip.driver?.car.model}'),
                    Text('Biển số xe: ${trip.driver?.car.licensePlate}'),
                    Text('Số điện thoại tài xế: ${trip.driver?.phone}'),
                    const Text('Vui lòng tìm tài xế của bạn gần đó'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigateToOnTripScreen(trip);
              },
              child: const Text(
                'Xác nhận',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDependentDriverInfoDialog(TripModel trip) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Tài xế ${widget.driverName} đã đến',
            ),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Bạn đã đặt xe: ${trip.driver?.car.make} ${trip.driver?.car.model}'),
                    Text('Biển số xe: ${trip.driver?.car.licensePlate}'),
                    Text('Số điện thoại tài xế: ${trip.driver?.phone}'),
                    const Text(
                      'Vui lòng thông báo cho người thân của bạn.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigateToGuardianObserverScreen(trip);
              },
              child: const Text(
                'Xác nhận',
              ),
            ),
          ],
        );
      },
    ).then((value) {
      navigateToGuardianObserverScreen(trip);
    });
  }

  void navigateToOnTripScreen(
    TripModel trip,
  ) {
    context.replaceNamed(RouteConstants.onTrip, extra: {
      'trip': trip,
    });
  }

  void navigateToGuardianObserverScreen(
    TripModel trip,
  ) {
    context.replaceNamed(RouteConstants.guardianObserveDependentTrip, extra: {
      'trip': trip,
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void updateMarker(double latitude, double longitude) async {
    if (mounted) {
      List<Marker> tempMarkers = []; // Temporary list to hold the new markers

      // Wait for a while before updating the marker
      await Future.delayed(const Duration(seconds: 3));
      print('did update marker');
      // Add the new marker to the temporary list
      tempMarkers.clear();
      temp.clear();
      tempMarkers.add(
        Marker(
          child: _markerWidget(
            const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
          ),
          latLng: LatLng(
            latitude,
            longitude,
          ),
        ),
      );
      setState(() {
        temp = tempMarkers;
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: temp.first.latLng,
              zoom: 15.5,
              tilt: 0,
            ),
          ),
        );
      });
    }
  }

  //   // Update the markers list
  // }

  void navigateToChatScreen() {
    context.pushNamed(RouteConstants.chat, pathParameters: {
      'receiver': widget.driverId,
      'driverAvatar': widget.driverAvatar,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? const Loader()
            : Stack(
                children: [
                  SafeArea(
                    top: false,
                    child: VietmapGL(
                      //dragEnabled: false,
                      compassEnabled: false,
                      myLocationEnabled: true,
                      styleString:
                          'https://api.maptiler.com/maps/basic-v2/style.json?key=erfJ8OKYfrgKdU6J1SXm',
                      initialCameraPosition: const CameraPosition(
                        zoom: 17.5, target: LatLng(10.736657, 106.672240),
                        // LatLng(
                        //   currentLocation?.latitude ?? 0,
                        //   currentLocation?.longitude ?? 0,
                        // ),
                      ),
                      onMapCreated: (VietmapController controller) {
                        setState(() {
                          _mapController = controller;
                        });
                      },

                      onMapRenderedCallback: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        // final location = ref.read(locationProvider);
                        // currentLocation = await location.getCurrentLocation();
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(currentLocation?.latitude ?? 0,
                                    currentLocation?.longitude ?? 0),
                                zoom: 17.5,
                                tilt: 0),
                          ),
                        );

                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * .95,
                    top: MediaQuery.of(context).viewPadding.top + 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              if (context.mounted) {
                                context.pop();
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black, // Customize the color
                                ),
                                SizedBox(width: 8), // Adjust spacing as needed
                                Text(
                                  'Quay lại',
                                  style: TextStyle(
                                    fontSize: 16, // Customize the font size
                                    color: Colors.black, // Customize the color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _mapController == null
                  //     ? const SizedBox.shrink()
                  //     : MarkerLayer(
                  //         ignorePointer: true,
                  //         mapController: _mapController!,
                  //         markers: temp,
                  //       ),
                  _mapController == null
                      ? const SizedBox.shrink()
                      : MarkerLayer(
                          ignorePointer: true,
                          mapController: _mapController!,
                          markers: temp,
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        // Adjust height based on the swipe direction
                        setState(() {
                          _containerHeight += details.primaryDelta!;
                          // Clamp the height between 60 and 300
                          _containerHeight = _containerHeight.clamp(
                              60.0, MediaQuery.of(context).size.height * .35);
                        });
                      },
                      onVerticalDragEnd: (details) {
                        // Determine whether to fully reveal or hide the container based on the gesture velocity
                        if (details.primaryVelocity! > 0) {
                          // Swipe down
                          setState(() {
                            _containerHeight = 60.0;
                          });
                        } else {
                          // Swipe up
                          setState(() {
                            _containerHeight =
                                MediaQuery.of(context).size.height * .35;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(12.0),
                        duration: const Duration(milliseconds: 300),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              30,
                            ),
                          ),
                        ),
                        height: _containerHeight,
                        //color: Pallete.primaryColor,
                        child: _containerHeight > 60
                            ? Column(
                                children: [
                                  Text(
                                    widget.driverName,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    //mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              widget.driverCarType,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              widget.driverPlate,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              widget.driverPhone,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  navigateToChatScreen();
                                                },
                                                child: const Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black54,
                                                      radius: 20,
                                                      child: Icon(
                                                        color: Colors.white,
                                                        IconData(0xe153,
                                                            fontFamily:
                                                                'MaterialIcons'),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            4), // Adjust the spacing as needed
                                                    Text(
                                                      'Chat',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w700 // Adjust the font size as needed
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(
                                            widget.driverAvatar,
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .4,
                                ),
                                child: const Divider(
                                  //height: 1,
                                  color: Colors.grey,
                                  thickness: 5,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
      ),
    );
  }

  _markerWidget(IconData icon) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Center(
        child: CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(
            widget.driverAvatar,
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/models/vietmap_route_model.dart';
import 'package:location/location.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/signalr_providers.dart';
import 'package:goshare/theme/pallet.dart';

class GuardianObserveDependentTripScreen extends ConsumerStatefulWidget {
  final TripModel trip;
  const GuardianObserveDependentTripScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GuardianObserveDependentTripScreenState();
}

class _GuardianObserveDependentTripScreenState
    extends ConsumerState<GuardianObserveDependentTripScreen> {
  double _containerHeight = 60.0;
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  LocationData? currentLocation;
  bool _isLoading = false;
  PolylinePoints polylinePoints = PolylinePoints();
  VietMapRouteModel? routeModel;
  @override
  void dispose() {
    //revokeHub();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await initSignalR(ref);
      await initSignalR(ref);
      final location = ref.read(locationProvider);
      currentLocation = await location.getCurrentLocation();
      //updateMarker();
      setState(() {});
    });
    super.initState();
  }

  void revokeHub() async {
    final hubConnection = await ref.read(
      hubConnectionProvider.future,
    );
    hubConnection.off('NotifyPassengerTripEnded');
  }

  void updateMarker(double latitude, double longitude) async {
    if (mounted) {
      List<Marker> tempMarkers = []; // Temporary list to hold the new markers

      // Wait for a while before updating the marker
      await Future.delayed(const Duration(seconds: 1));
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

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.watch(
        hubConnectionProvider.future,
      );

      hubConnection.on(
        'UpdateDriverLocation',
        (arguments) {
          if (mounted) {
            if (ModalRoute.of(context)?.isCurrent ?? false) {
              final stringData = arguments?.first as String;
              print(stringData);
              final data = jsonDecode(stringData) as Map<String, dynamic>;
              updateMarker(
                data['latitude'],
                data['longitude'],
              );
            }
          }
        },
      );

      hubConnection.on('NotifyPassengerTripEnded', (message) {
        if (mounted) {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            _handleNotifyPassengerDriverPickUp(message);
          }
        }
      });

      hubConnection.onclose((exception) async {
        await Future.delayed(
          const Duration(seconds: 3),
          () async {
            if (hubConnection.state == HubConnectionState.disconnected) {
              await hubConnection.start();
            }
          },
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleNotifyPassengerDriverPickUp(dynamic message) {
    if (mounted) {
      final data = message as List<dynamic>;
      final tripData = data.cast<Map<String, dynamic>>().first;
      final trip = TripModel.fromMap(tripData);
      if (trip.passengerId == widget.trip.passengerId) {
        _showDriverInfoDialog(trip);
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
              'Chuyến đi của người thân, ${trip.passenger.name} đã hoàn thành',
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
                      'Tài xế ${trip.passenger.name} đã hoàn thành chuyến cho người thân ${trip.passenger.name}',
                    ),
                    Text(
                      'Số tiền thanh toán là ${trip.price} qua hình thức trả bằng ${trip.paymentMethod == 0 ? 'Ví' : 'Tiền mặt'}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigateToDashBoardScreen();
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

  void navigateToDashBoardScreen() {
    context.goNamed(
      RouteConstants.dashBoard,
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // void updateMarker() async {
  //   if (mounted) {
  //     List<Marker> tempMarkers = []; // Temporary list to hold the new markers

  //     for (var latLng in latLngList) {
  //       // Wait for a while before updating the marker
  //       await Future.delayed(const Duration(seconds: 8));
  //       print('did update marker');
  //       // Add the new marker to the temporary list
  //       tempMarkers.clear();
  //       temp.clear();
  //       tempMarkers.add(
  //         Marker(
  //           child: _markerWidget(
  //             const IconData(0xe1d7, fontFamily: 'MaterialIcons'),
  //           ),
  //           latLng: latLng,
  //         ),
  //       );
  //       setState(() {
  //         temp = tempMarkers;
  //         _mapController?.animateCamera(CameraUpdate.newCameraPosition(
  //             CameraPosition(target: temp.first.latLng, zoom: 10, tilt: 0)));
  //       });
  //     }
  //   }

  //   // Update the markers list
  // }

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

                        final data = await LocationUtils.getRoute(
                          widget.trip.startLocation.latitude,
                          widget.trip.startLocation.longitude,
                          widget.trip.endLocation.latitude,
                          widget.trip.endLocation.longitude,
                        );
                        data.fold(
                          (l) {
                            showSnackBar(
                                context: context,
                                message: 'Có lỗi khi lấy tuyến đường tài xế');
                          },
                          (r) => routeModel = r,
                        );
                        if (routeModel != null) {
                          List<PointLatLng> pointLatLngList =
                              polylinePoints.decodePolyline(
                            routeModel!.paths[0].points,
                          );
                          List<LatLng> latLngList = pointLatLngList
                              .map(
                                (point) =>
                                    LatLng(point.latitude, point.longitude),
                              )
                              .toList();
                          await _mapController?.addPolyline(
                            PolylineOptions(
                              //polylineGapWidth: 0,
                              geometry: latLngList,
                              polylineColor: Pallete.primaryColor,
                              polylineWidth: 6.5,
                              polylineOpacity: 1,
                              draggable: false,
                              polylineBlur: 0.8,
                            ),
                          );
                        }
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(
                                  widget.trip.startLocation.latitude,
                                  widget.trip.startLocation.longitude,
                                ),
                                zoom: 15.5,
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
                                context.goNamed(
                                  RouteConstants.dashBoard,
                                );
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
                            60.0,
                            MediaQuery.of(context).size.height * .3,
                          );
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
                                MediaQuery.of(context).size.height * .3;
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
                                    widget.trip.driver?.name ?? 'Không rõ',
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
                                              widget.trip.driver?.car.make ??
                                                  'Không rõ',
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              widget.trip.driver?.car
                                                      .licensePlate ??
                                                  'Không rõ',
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              widget.trip.driver?.phone ??
                                                  'Không rõ',
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(
                                            widget.trip.driver?.avatarUrl ?? '',
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
            widget.trip.driver?.avatarUrl ?? '',
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';
import 'package:location/location.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/helpers.dart';
import 'package:vietmap_flutter_navigation/models/marker.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/signalr_providers.dart';

class OnTripScreen extends ConsumerStatefulWidget {
  final TripModel trip;
  const OnTripScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnTripScreenState();
}

class _OnTripScreenState extends ConsumerState<OnTripScreen> {
  MapNavigationViewController? _controller;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  LocationData? currentLocation;
  bool _isRouteBuilt = false;
  bool _isLoading = false;
  double _containerHeight = 60.0;
  List<WayPoint> wayPoints = [
    WayPoint(name: "origin point", latitude: 10.759091, longitude: 106.675817),
    WayPoint(
        name: "destination point", latitude: 10.762528, longitude: 106.653099)
  ];
  @override
  void initState() {
    // TODO: implement initState
    if (!mounted) return;
    initialize().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        print('đang ở màn hình on trip nè');
        await initSignalR(ref);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //revokeHub();
    super.dispose();
  }

  void revokeHub() async {
    final hubConnection = await ref.read(
      hubConnectionProvider.future,
    );
    hubConnection.off('NotifyPassengerTripEnded');
  }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on(
        'NotifyPassengerTripEnded',
        (message) {
          try {
            print('ON TRIP ENDED ON_TRIP');
            if (mounted) {
              if (ModalRoute.of(context)?.isCurrent ?? false) {
                final data = message as List<dynamic>;
                bool isSelfBook = data.cast<bool>()[1];
                bool isNotifyToGuardian = data.cast<bool>()[2];
                ref
                    .read(currentOnTripIdProvider.notifier)
                    .setCurrentOnTripId(null);

                if (isSelfBook == true) {
                  print("SELF BOOK");
                  if (mounted) {
                    ref
                        .read(currentOnTripIdProvider.notifier)
                        .setCurrentOnTripId(null);
                    context.replaceNamed(RouteConstants.rating);
                  }
                } else {
                  if (isNotifyToGuardian == false) {
                    ref.read(stageProvider.notifier).setStage(Stage.stage0);
                    if (mounted) {
                      context
                          .replaceNamed(RouteConstants.rating, pathParameters: {
                        'idTrip': widget.trip.id,
                      });
                    }
                  }
                }
              }
            }
          } catch (e) {
            print(e.toString());
            rethrow;
          }
        },
      );

      hubConnection.onclose(
        (exception) async {
          await Future.delayed(
            const Duration(seconds: 3),
            () async {
              if (mounted) {
                if (hubConnection.state == HubConnectionState.disconnected) {
                  await hubConnection.start();
                }
              }
            },
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void navigateToDashBoard() {
    context.goNamed(RouteConstants.dashBoard);
  }

  Future<void> initialize() async {
    if (!mounted) return;

    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = false;
    _navigationOption.alternatives = false;
    _navigationOption.apiKey =
        'c3d0f188ff669f89042771a20656579073cffec5a8a69747';
    _navigationOption.mapStyle =
        "https://api.maptiler.com/maps/basic-v2/style.json?key=erfJ8OKYfrgKdU6J1SXm";
    _navigationOption.customLocationCenterIcon =
        await VietMapHelper.getBytesFromAsset('assets/download.jpeg');
    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NavigationView(
              mapOptions: _navigationOption,
              onNewRouteSelected: (p0) {},
              onMapCreated: (p0) async {
                _controller = p0;
              },
              onRouteBuilt: (p0) {
                setState(() {
                  //EasyLoading.dismiss();
                  _isRouteBuilt = true;
                });
              },
              onMapRendered: () async {
                setState(() {
                  _isLoading = true;
                });
                _controller?.setCenterIcon(
                  await VietMapHelper.getBytesFromAsset('assets/download.jpeg'),
                );
                currentLocation = await location.getCurrentLocation();
                wayPoints.clear();
                wayPoints.add(
                  WayPoint(
                    name: 'origin point',
                    latitude: currentLocation?.latitude,
                    longitude: currentLocation?.longitude,
                  ),
                );
                wayPoints.add(
                  WayPoint(
                    name: 'destination point',
                    latitude: widget.trip.endLocation.latitude,
                    longitude: widget.trip.endLocation.longitude,
                  ),
                );
                _controller?.addImageMarkers([
                  Marker(
                    imagePath: 'assets/images/marker.png',
                    latLng: LatLng(
                      widget.trip.endLocation.latitude,
                      widget.trip.endLocation.longitude,
                    ),
                  ),
                ]);
                _controller?.buildRoute(wayPoints: wayPoints);
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            !_isRouteBuilt
                ? const SizedBox.shrink()
                : Positioned(
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
                              widget.trip.driver?.name ?? 'Tên không rõ',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              //mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                            'Xe không rõ',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        widget.trip.driver?.car.licensePlate ??
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
                                            'SĐT không rõ',
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
                                widget.trip.driver != null
                                    ? widget.trip.driver?.avatarUrl != null
                                        ? Center(
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: NetworkImage(
                                                widget.trip.driver!.avatarUrl!,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * .4,
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:location/location.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/helpers.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

import 'package:goshare/core/locations_util.dart';
import 'package:goshare/providers/signalr_providers.dart';

class OnTripScreen extends ConsumerStatefulWidget {
  final String driverName;
  final String driverPhone;
  final String driverAvatar;
  final String driverPlate;
  final String driverCarType;
  final String driverId;
  final String endLatitude;
  final String endLongitude;
  const OnTripScreen({
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
  ConsumerState<ConsumerStatefulWidget> createState() => _OnTripScreenState();
}

class _OnTripScreenState extends ConsumerState<OnTripScreen> {
  MapNavigationViewController? _controller;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  LocationData? currentLocation;
  bool _isRouteBuilt = false;
  bool _isLoading = false;
  List<WayPoint> wayPoints = [
    WayPoint(name: "origin point", latitude: 10.759091, longitude: 106.675817),
    WayPoint(
        name: "destination point", latitude: 10.762528, longitude: 106.653099)
  ];
  @override
  void initState() {
    // TODO: implement initState
    initialize().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await initSignalR(ref);
      });
    });
    super.initState();
  }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.watch(
        hubConnectionProvider.future,
      );

      hubConnection.on('NotifyPassengerTripEnded', (message) {
        print('hehehehehehe');
        print(" DAY ROI SIGNAL R DAY ROI ${message.toString()}");
        setState(() {
          ref.watch(currentOnTripIdProvider.notifier).setCurrentOnTripId(null);
        });
        context.goNamed(RouteConstants.rating);
      });

      hubConnection.onclose((exception) async {
        print(exception.toString() + "LOI CUA SIGNALR ON CLOSE");
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
              onNewRouteSelected: (p0) {
                print(p0.toString());
              },
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
                    latitude: double.parse(widget.endLatitude),
                    longitude: double.parse(widget.endLongitude),
                  ),
                );
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

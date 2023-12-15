import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/floating_search_bar.dart';
import 'package:goshare/models/vietmap_place_model.dart';
import 'package:goshare/theme/pallet.dart';

import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import 'package:flutter/material.dart';

class SearchTripRouteScreen extends ConsumerStatefulWidget {
  const SearchTripRouteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchTripRouteScreenState();
}

class _SearchTripRouteScreenState extends ConsumerState<SearchTripRouteScreen> {
  // MapNavigationViewController? _controller;
  String currentAddress = '';
  double lat = 0.0;
  double lon = 0.0;
  VietmapController? _mapController;
  List<Marker> temp = [];
  double _containerHeight = 60.0;
  Marker _marker = Marker(
    child: const SizedBox.shrink(),
    latLng: const LatLng(0, 0),
  );
  bool _isPlaceMarker = false;
  bool _isLoading = false;
  FocusNode focusNode = FocusNode();
  LocationData? currentLocation;
  UserLocation? userLocation;

  @override
  void initState() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      final location = ref.read(locationProvider);
      currentLocation = await location.getCurrentLocation();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  void navigateToCarChoosingScreen(
    BuildContext context,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
  ) {
    context.pushNamed(RouteConstants.carChoosing, pathParameters: {
      'startLatitude': startLatitude?.toString() ?? '',
      'startLongitude': startLongitude?.toString() ?? '',
      'endLatitude': endLatitude?.toString() ?? '',
      'endLongitude': endLongitude?.toString() ?? '',
    });
  }

  void navigateToCreateDestination() {
    context.pushNamed(RouteConstants.createDestination, pathParameters: {
      'destinationAddress': currentAddress,
    }, extra: {
      'latitude': lat,
      'longitude': lon
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // setState(() {
          //   _isLoading = true;
          // });
          // final location = ref.read(locationProvider);
          // currentLocation = await location.getCurrentLocation();
          // setState(() {
          //   _isLoading = false;
          // });
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  userLocation?.position.latitude ?? 0,
                  userLocation?.position.longitude ?? 0,
                ),
                zoom: 17.5,
                tilt: 0,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.location_on,
        ),
      ),
      body: currentLocation == null
          ? const Loader()
          : Stack(
              children: [
                Stack(
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
                          zoom: 17.5,
                          target: LatLng(
                            10.736657,
                            106.672240,
                          ),
                          //     LatLng(
                          //   currentLocation?.latitude ?? 0,
                          //   currentLocation?.longitude ?? 0,
                          // ),
                        ),
                        onMapCreated: (VietmapController controller) {
                          setState(() {
                            _mapController = controller;
                          });
                        },
                        onUserLocationUpdated: (location) {
                          setState(() {
                            userLocation = location;
                          });
                        },
                        onMapLongClick: (point, coordinates) async {
                          final res = await ref
                              .watch(homeControllerProvider.notifier)
                              .searchLocationReverse(
                                context,
                                coordinates.longitude,
                                coordinates.latitude,
                              );
                          setState(() {
                            currentAddress = res.address ?? '';

                            lat = coordinates.latitude;
                            lon = coordinates.longitude;
                            _marker = Marker(
                              child: MyMarker(
                                icon: Icons.location_on,
                                address: currentAddress,
                              ),
                              // _markerWidget(
                              //     Icons.location_on, currentAddress),
                              latLng: LatLng(
                                coordinates.latitude,
                                coordinates.longitude,
                              ),
                            );
                            _mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: _marker.latLng,
                                    zoom: 15.5,
                                    tilt: 0),
                              ),
                            );
                            _isLoading = false;
                            _isPlaceMarker = true;
                          });
                        },
                        onMapRenderedCallback: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          // final location = ref.read(locationProvider);
                          // currentLocation = await location.getCurrentLocation();
                          await _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(currentLocation?.latitude ?? 0,
                                      currentLocation?.longitude ?? 0),
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
                      top: MediaQuery.of(context).viewInsets.top + 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Text(
                                      'Quay lại',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FloatingSearchBar(
                            focusNode: focusNode,
                            onSearchItemClick: (p0) async {
                              //EasyLoading.show();
                              setState(() {
                                _isLoading = true;
                              });
                              VietmapPlaceModel? data;
                              var res = await LocationUtils.getPlaceDetail(
                                  p0.refId ?? '');

                              // GetPlaceDetailUseCase(VietmapApiRepositories())
                              //     .call(p0.refId ?? '');
                              res.fold((l) {
                                setState(() {
                                  _isLoading = false;
                                });
                                //EasyLoading.dismiss();
                                return;
                              }, (r) {
                                data = r;
                                print('${data?.lat} + ${data?.lng}');
                                setState(() {
                                  currentAddress =
                                      '${data?.address}, ${data?.ward}, ${data?.district}, ${data?.city}';
                                  lat = data?.lat ?? 0.0;
                                  lon = data?.lng ?? 0.0;
                                  _marker = Marker(
                                    child: MyMarker(
                                      icon: Icons.location_on,
                                      address: currentAddress,
                                    ),
                                    // _markerWidget(
                                    //     Icons.location_on, currentAddress),
                                    latLng: LatLng(
                                      data?.lat ?? 0,
                                      data?.lng ?? 0,
                                    ),
                                  );
                                  _mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                          target: _marker.latLng,
                                          zoom: 15.5,
                                          tilt: 0),
                                    ),
                                  );
                                  _isLoading = false;
                                  _isPlaceMarker = true;
                                });
                              });
                              setState(() {
                                _isLoading = false;
                              });
                            },
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
                            markers: [
                              _marker,
                            ],
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
                                60.0, MediaQuery.of(context).size.height * .3);
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
                                ? _isPlaceMarker
                                    ? Column(
                                        children: [
                                          const Text(
                                            'Lựa chọn ',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Chọn hành động bạn muốn với địa điểm này',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                focusNode.unfocus();
                                                navigateToCarChoosingScreen(
                                                  context,
                                                  currentLocation?.latitude,
                                                  currentLocation?.longitude,
                                                  _marker.latLng.latitude,
                                                  _marker.latLng.longitude,
                                                );
                                              },
                                              child: const Text('Đặt xe'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                navigateToCreateDestination();
                                              },
                                              child: const Text(
                                                'Lưu điểm đến',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Center(
                                        child: Text('Vui lòng chọn điểm đến'),
                                      )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              .4,
                                    ),
                                    child: const Divider(
                                      //height: 1,
                                      color: Colors.grey,
                                      thickness: 5,
                                    ),
                                  )),
                      ),
                    ),
                  ],
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
    );
  }

  @override
  void dispose() {
    try {
      _mapController?.dispose();
    } catch (_) {}
    super.dispose();
  }

  // _markerWidget(IconData icon, String address) {
  //   bool showAddress = false;

  //   return GestureDetector(
  //     onTap: () {
  //       // Toggle between showing "Điểm đến" and the address
  //       showAddress = !showAddress;
  //     },
  //     child: Column(
  //       children: [
  //         Container(
  //           decoration: const BoxDecoration(
  //             shape: BoxShape.rectangle,
  //             color: Colors.white,
  //           ),
  //           child: Text(
  //             showAddress ? address ?? 'Điểm đến' : 'Điểm đến',
  //           ),
  //         ),
  //         SizedBox(
  //           width: 40,
  //           height: 40,
  //           child: Icon(icon, color: Pallete.primaryColor, size: 40),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class MyMarker extends StatefulWidget {
  final IconData icon;
  final String address;

  const MyMarker({
    Key? key,
    required this.icon,
    required this.address,
  }) : super(key: key);

  @override
  State createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  bool showAddress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print('hehe');
          showAddress = !showAddress;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: Text(
              showAddress ? widget.address : 'Điểm đến',
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Icon(widget.icon, color: Pallete.primaryColor, size: 40),
          ),
        ],
      ),
    );
  }
}

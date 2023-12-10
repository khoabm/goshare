import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/models/vietmap_route_model.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
//import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class RouteConfirmScreen extends ConsumerStatefulWidget {
  final String startLongitude;
  final String startLatitude;
  final String endLongitude;
  final String endLatitude;
  final String paymentMethod;
  final String bookerId;
  final String carTypeId;
  final String? driverNote;
  final String? nonAppDepName;
  final String? nonAppDepPhone;
  const RouteConfirmScreen({
    this.driverNote,
    this.nonAppDepName,
    this.nonAppDepPhone,
    super.key,
    required this.startLongitude,
    required this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
    required this.paymentMethod,
    required this.bookerId,
    required this.carTypeId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends ConsumerState<RouteConfirmScreen> {
  // Widget instructionImage = const SizedBox.shrink();
  // String guideDirection = "";
  // Widget recenterButton = const SizedBox.shrink();
  // RouteProgressEvent? routeProgressEvent;

  VietmapController? _controller;
  UserLocation? userLocation;
  PolylinePoints polylinePoints = PolylinePoints();
  VietMapRouteModel? routeModel;
  List<Marker> temp = [];
  bool _isRouteBuilt = false;

  bool _isLoading = false;
  String driverName = '';
  String driverPhone = '';
  String driverAvatar = '';
  String driverPlate = '';
  String driverCarType = '';

  @override
  void initState() {
    // _showDriverInfoDialog();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // setState(() {
      //   _isLoading = true;
      // });
      // print('DAY LA CHO INITTTTTTTTTTTTT');
      // print(widget.bookerId);
      // print(widget.paymentMethod);
      // print(widget.startLatitude);
      // print(widget.startLongitude);
      // print(widget.carTypeId);
      // print(widget.endLatitude);
      // print(widget.endLongitude);
      // print(
      //     '===================================================================');
      // // Use setState to trigger a rebuild of the widget with the new data.
      // setState(() {
      //   _isLoading = false;
      // });
    });

    // Use setState to trigger a rebuild of the widget with the new data.
    // setState(() {
    //   _isLoading = false;
    // });

    super.initState();
  }

  //MapOptions? options;

  // void navigateToSearchTripRoute() {
  //   context.replaceNamed(RouteConstants.searchTripRoute);
  // }

  void navigateToFindTrip() {
    context.replaceNamed(RouteConstants.findTrip, extra: {
      'startLatitude': widget.startLatitude,
      'startLongitude': widget.startLongitude,
      'endLatitude': widget.endLatitude,
      'endLongitude': widget.endLongitude,
      'paymentMethod': widget.paymentMethod.toString(),
      'bookerId': widget.bookerId,
      'carTypeId': widget.carTypeId,
      'driverNote': widget.driverNote,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: const EdgeInsets.all(
          12.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              50,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xác nhận tuyến đường',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   'Đại chỉ',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // )
                    ],
                  ),
                ),
                //CircularProgressIndicator(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: ElevatedButton(
                onPressed: () {
                  //navigateToSearchTripRoute();
                  context.pop();
                },
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: ElevatedButton(
                onPressed: () {
                  navigateToFindTrip();
                },
                child: const Text('Tiếp tục'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // NavigationView(
            //   mapOptions: _navigationOption,
            //   onNewRouteSelected: (p0) {
            //     print(p0.toString());
            //   },
            //   onMapCreated: (p0) async {
            //     _controller = p0;
            //   },
            //   onRouteBuilt: (p0) {
            //     setState(() {
            //       //EasyLoading.dismiss();
            //       _isRouteBuilt = true;
            //     });
            //   },
            //   onMapRendered: () async {
            //     _controller?.setCenterIcon(
            //       await VietMapHelper.getBytesFromAsset('assets/download.jpeg'),
            //     );
            //     wayPoints.clear();
            //     wayPoints.add(
            //       WayPoint(
            //         name: 'origin point',
            //         latitude: double.parse(widget.startLatitude),
            //         longitude: double.parse(widget.startLongitude),
            //       ),
            //     );
            //     wayPoints.add(
            //       WayPoint(
            //         name: 'destination point',
            //         latitude: double.parse(widget.endLatitude),
            //         longitude: double.parse(widget.endLongitude),
            //       ),
            //     );
            //     _controller?.addImageMarkers([
            //       Marker(
            //         imagePath: 'assets/images/marker.png',
            //         latLng: LatLng(
            //           double.parse(widget.endLatitude),
            //           double.parse(widget.endLongitude),
            //         ),
            //       ),
            //     ]);
            //     // _controller?.addImageMarkers(Marker(child: child, latLng: latLng));
            //     _controller?.buildRoute(wayPoints: wayPoints);
            //   },
            //   // onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
            //   //   setState(() {
            //   //     this.routeProgressEvent = routeProgressEvent;
            //   //   });
            //   //   _setInstructionImage(routeProgressEvent.currentModifier,
            //   //       routeProgressEvent.currentModifierType);
            //   // },
            // ),
            VietmapGL(
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
                  _controller = controller;
                });
              },

              onMapRenderedCallback: () async {
                setState(() {
                  _isLoading = true;
                });

                final data = await LocationUtils.getRoute(
                  double.parse(widget.startLatitude),
                  double.parse(widget.startLongitude),
                  double.parse(widget.endLatitude),
                  double.parse(widget.endLongitude),
                );
                data.fold(
                  (l) {
                    // showSnackBar(
                    //   context: context,
                    //   message: 'Có lỗi khi lấy tuyến đường tài xế',
                    // );
                    print("CÓ LỖI KHI LẤY TUYẾN ĐƯỜNG");
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
                        (point) => LatLng(point.latitude, point.longitude),
                      )
                      .toList();
                  await _controller?.addPolyline(
                    PolylineOptions(
                      //polylineGapWidth: 0,
                      polylineOffset: 10,
                      geometry: latLngList,
                      polylineColor: Pallete.primaryColor,
                      polylineWidth: 6.5,
                      polylineOpacity: 1,
                      draggable: false,
                      polylineBlur: 0.8,
                    ),
                  );
                }
                _controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        double.parse(widget.startLatitude),
                        double.parse(widget.startLongitude),
                      ),
                      zoom: 14.5,
                      tilt: 0,
                    ),
                  ),
                );

                setState(() {
                  _isLoading = false;
                  _isRouteBuilt = true;
                });
              },
            ),
            _isRouteBuilt
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
                            onTap: () async {},
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
    // result == true
    //     ? const SizedBox(
    //         child: Text('true'),
    //       )
    //     : const SizedBox();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

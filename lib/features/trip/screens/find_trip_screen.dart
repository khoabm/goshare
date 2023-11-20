import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:signalr_core/signalr_core.dart';

import 'package:goshare/providers/signalr_providers.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/helpers.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/models/route_progress_event.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

class FindTripScreen2 extends ConsumerStatefulWidget {
  final String startLongitude;
  final String startLatitude;
  final String endLongitude;
  final String endLatitude;
  const FindTripScreen2({
    super.key,
    required this.startLongitude,
    required this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends ConsumerState<FindTripScreen2> {
  String result = '';
  MapNavigationViewController? _controller;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();

  List<WayPoint> wayPoints = [
    WayPoint(name: "origin point", latitude: 10.759091, longitude: 106.675817),
    WayPoint(
        name: "destination point", latitude: 10.762528, longitude: 106.653099)
  ];
  Widget instructionImage = const SizedBox.shrink();
  String guideDirection = "";
  Widget recenterButton = const SizedBox.shrink();
  RouteProgressEvent? routeProgressEvent;
  bool _isRouteBuilt = false;
  bool _isRunning = false;
  FocusNode focusNode = FocusNode();

  String driverName = '';
  String driverPhone = '';
  String driverAvatar = '';
  String driverPlate = '';
  String driverCarType = '';

  @override
  void initState() {
    initialize().then((value) {
      // _showDriverInfoDialog();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await initSignalR(ref).then((value) async {
          result = await ref.watch(tripControllerProvider.notifier).findDriver(
                context,
                FindTripModel(
                  startLatitude: 10.957545180946951,
                  startLongitude: 106.99406621587116,
                  startAddress: 'Nha Nguyen',
                  endLatitude: 10.94738262463184,
                  endLongitude: 106.97866792995985,
                  endAddress: 'Nga 3',
                  cartypeId: '60f79bc8-2853-492a-9d2e-cf2994102406',
                  paymentMethod: 2,
                ),
              );
        });

        // Use setState to trigger a rebuild of the widget with the new data.
        setState(() {});
      });
    });

    super.initState();
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

  //MapOptions? options;

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = ref.watch(
        hubConnectionProvider,
      );

      hubConnection.on('NotifyPassengerDriverOnTheWay', (message) {
        print("${message.toString()} DAY ROI SIGNAL R DAY ROI");
        _handleNotifyPassengerDriverOnTheWay(message);
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

  void _handleNotifyPassengerDriverOnTheWay(dynamic message) {
    // Parse the response and update the state with passenger information
    final passengerData =
        (message as List<dynamic>).cast<Map<String, dynamic>>().first;

    setState(() {
      driverName = passengerData['name'];
      driverPhone = passengerData['phone'];
      driverAvatar = passengerData['avatarUrl'];
      driverPlate = passengerData['car']['licensePlate'];
      driverCarType =
          passengerData['car']['model'] + " " + passengerData['car']['make'];
    });

    // Update the bottom sheet content
    _showDriverInfoDialog();
  }

  void _showDriverInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Đã tìm thấy tài xế',
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
                      driverName,
                    ),
                    Text(driverCarType),
                    Text(driverPlate),
                    Text(driverPhone),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 50,
                child: Image.network(
                  driverAvatar,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Xác nhận',
              ),
            ),
          ],
        );
      },
    );
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
        height: MediaQuery.of(context).size.height * .2,
        child: Column(
          children: [
            const Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vui lòng đợi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chúng tôi đang tìm tài xế cho bạn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: ElevatedButton(
                onPressed: () async {
                  if (result.isNotEmpty) {
                    final check = await ref
                        .watch(tripControllerProvider.notifier)
                        .cancelTrip(
                          context,
                          result,
                        );
                    if (check) {
                      if (context.mounted) {
                        context.goNamed(RouteConstants.dashBoard);
                      }
                    }
                  }
                },
                child: const Text('Hủy'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NavigationView(
              mapOptions: _navigationOption,
              onNewRouteSelected: (p0) {
                print(p0.toString());
              },
              onMapCreated: (p0) async {
                _controller = p0;
              },
              onMapMove: () => _showRecenterButton(),
              onRouteBuilt: (p0) {
                setState(() {
                  //EasyLoading.dismiss();
                  _isRouteBuilt = true;
                });
              },
              onMapRendered: () async {
                _controller?.setCenterIcon(
                  await VietMapHelper.getBytesFromAsset('assets/download.jpeg'),
                );
                _controller?.buildRoute(wayPoints: wayPoints);
                // _controller?.buildAndStartNavigation(
                //   wayPoints: wayPoints,
                // );
              },
              onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
                setState(() {
                  this.routeProgressEvent = routeProgressEvent;
                });
                _setInstructionImage(routeProgressEvent.currentModifier,
                    routeProgressEvent.currentModifierType);
              },
              // onArrival: () {
              //   _isRunning = false;
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Container(
              //         height: 100,
              //         color: Colors.red,
              //         child: const Text('Bạn đã tới đích'),
              //       ),
              //     ),
              //   );
              // },
            ),
            // Positioned(
            //     top: MediaQuery.of(context).viewPadding.top,
            //     left: 0,
            //     child: BannerInstructionView(
            //       routeProgressEvent: routeProgressEvent,
            //       instructionIcon: instructionImage,
            //     )),
            // Positioned(
            //     bottom: 0,
            //     child: BottomActionView(
            //       recenterButton: recenterButton,
            //       controller: _controller,
            //       onOverviewCallback: _showRecenterButton,
            //       onStopNavigationCallback: _onStopNavigation,
            //       routeProgressEvent: routeProgressEvent,
            //     )),
            _isRunning
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
                            onTap: () {
                              Navigator.of(context).pop();
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
                        // IconButton(
                        //   onPressed: () {
                        //     context.pop();
                        //   },
                        //   icon: SizedBox(
                        //     width: MediaQuery.of(context).size.width * .95,
                        //     child: const Row(
                        //       children: [
                        //         Icon(Icons.arrow_back_ios_new_outlined),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Text(
                        //           'Quay lại',
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // FloatingSearchBar(
                        //   focusNode: focusNode,
                        //   onSearchItemClick: (p0) async {
                        //     //EasyLoading.show();

                        //     VietmapPlaceModel? data;
                        //     var res = await LocationUtils.getPlaceDetail(
                        //         p0.refId ?? '');

                        //     // GetPlaceDetailUseCase(VietmapApiRepositories())
                        //     //     .call(p0.refId ?? '');
                        //     res.fold((l) {
                        //       print(l.message);
                        //       //EasyLoading.dismiss();
                        //       return;
                        //     }, (r) {
                        //       print(r.address);
                        //       data = r;
                        //     });
                        //     wayPoints.clear();
                        //     // var location = await Geolocator.getCurrentPosition(
                        //     //   desiredAccuracy: LocationAccuracy.bestForNavigation,
                        //     // );
                        //     // wayPoints.add(
                        //     //   WayPoint(
                        //     //     name: 'destination',
                        //     //     latitude: location.latitude,
                        //     //     longitude: location.longitude,
                        //     //   ),
                        //     // );
                        //     if (data?.lat != null) {
                        //       wayPoints.add(WayPoint(
                        //           name: '',
                        //           latitude: data?.lat,
                        //           longitude: data?.lng));
                        //     }
                        //     _controller?.buildRoute(wayPoints: wayPoints);
                        //   },
                        // ),
                      ],
                    )),
            // _isRouteBuilt && !_isRunning
            //     ? Positioned(
            //         bottom: 20,
            //         left: 0,
            //         child: SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               ElevatedButton(
            //                   style: ButtonStyle(
            //                       shape: MaterialStateProperty.all<
            //                               RoundedRectangleBorder>(
            //                           RoundedRectangleBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(18.0),
            //                               side: const BorderSide(
            //                                   color: Colors.blue)))),
            //                   onPressed: () {
            //                     // _isRunning = true;
            //                     // _controller?.startNavigation();
            //                   },
            //                   child: const Text('Tiep tuc')),
            //               ElevatedButton(
            //                   style: ButtonStyle(
            //                       shape: MaterialStateProperty.all<
            //                               RoundedRectangleBorder>(
            //                           RoundedRectangleBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(18.0),
            //                               side: const BorderSide(
            //                                   color: Colors.blue)))),
            //                   onPressed: () {
            //                     _controller?.clearRoute();
            //                     setState(() {
            //                       _isRouteBuilt = false;
            //                     });
            //                   },
            //                   child: const Text('Xoá tuyến đường')),
            //             ],
            //           ),
            //         ),
            //       )
            //     : const SizedBox.shrink()
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

  _showRecenterButton() {
    recenterButton = TextButton(
        onPressed: () {
          _controller?.recenter();
          setState(() {
            recenterButton = const SizedBox.shrink();
          });
        },
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                border: Border.all(color: Colors.black45, width: 1)),
            child: const Row(
              children: [
                Icon(
                  Icons.keyboard_double_arrow_up_sharp,
                  color: Colors.lightBlue,
                  size: 35,
                ),
                Text(
                  'Về giữa',
                  style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                )
              ],
            )));
    setState(() {});
  }

  _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      List<String> data = [
        type.replaceAll(' ', '_'),
        modifier.replaceAll(' ', '_')
      ];
      String path = 'assets/navigation_symbol/${data.join('_')}.svg';
      setState(() {
        instructionImage = SvgPicture.asset(path, color: Colors.white);
      });
    }
  }

  _onStopNavigation() {
    setState(() {
      routeProgressEvent = null;
      _isRunning = false;
    });
  }

  // _showBottomSheetInfo(VietmapReverseModel data) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (_) => AddressInfo(
  //             data: data,
  //             buildRoute: () async {
  //               EasyLoading.show();
  //               wayPoints.clear();
  //               var location = await Geolocator.getCurrentPosition();

  //               wayPoints.add(WayPoint(
  //                   name: 'destination',
  //                   latitude: location.latitude,
  //                   longitude: location.longitude));
  //               if (data.lat != null) {
  //                 wayPoints.add(WayPoint(
  //                     name: '', latitude: data.lat, longitude: data.lng));
  //               }
  //               _controller?.buildRoute(wayPoints: wayPoints);
  //               if (!mounted) return;
  //               Navigator.pop(context);
  //             },
  //             buildAndStartRoute: () async {
  //               EasyLoading.show();
  //               wayPoints.clear();
  //               var location = await Geolocator.getCurrentPosition();
  //               wayPoints.add(WayPoint(
  //                   name: 'destination',
  //                   latitude: location.latitude,
  //                   longitude: location.longitude));
  //               if (data.lat != null) {
  //                 wayPoints.add(WayPoint(
  //                     name: '', latitude: data.lat, longitude: data.lng));
  //               }
  //               _controller?.buildAndStartNavigation(
  //                   wayPoints: wayPoints,
  //                   profile: DrivingProfile.drivingTraffic);
  //               setState(() {
  //                 _isRunning = true;
  //               });
  //               if (!mounted) return;
  //               Navigator.pop(context);
  //             },
  //           ));
  // }

  @override
  void dispose() {
    _controller?.onDispose();
    super.dispose();
  }
}

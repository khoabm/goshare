import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/models/user_data_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:signalr_core/signalr_core.dart';

import 'package:goshare/providers/signalr_providers.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/helpers.dart';
import 'package:vietmap_flutter_navigation/models/marker.dart';
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
  final String paymentMethod;
  final String bookerId;
  final String carTypeId;
  final String? driverNote;
  final bool? isFindingTrip;
  const FindTripScreen2({
    this.driverNote,
    super.key,
    required this.startLongitude,
    required this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
    required this.paymentMethod,
    required this.bookerId,
    required this.carTypeId,
    this.isFindingTrip = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends ConsumerState<FindTripScreen2> {
  TripModel? result;
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
  bool _isLoading = false;
  String driverName = '';
  String driverPhone = '';
  String driverAvatar = '';
  String driverPlate = '';
  String driverCarType = '';
  String driverId = '';

  @override
  void initState() {
    initialize().then((value) {
      // _showDriverInfoDialog();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        setState(() {
          _isLoading = true;
        });
        await initSignalR(ref);
        if (widget.bookerId == ref.read(userProvider.notifier).state?.id) {
          if (context.mounted) {
            result = await ref.read(tripControllerProvider.notifier).findDriver(
                  context,
                  FindTripModel(
                    startLatitude: double.parse(widget.startLatitude),
                    startLongitude: double.parse(widget.startLongitude),
                    //startAddress: 'Nha Nguyen',
                    endLatitude: double.parse(widget.endLatitude),
                    endLongitude: double.parse(widget.endLongitude),
                    //endAddress: 'Nga 3',
                    cartypeId: widget.carTypeId,
                    paymentMethod: int.parse(widget.paymentMethod),
                  ),
                );
          }

          if (result != null) {
            ref
                .read(currentOnTripIdProvider.notifier)
                .setCurrentOnTripId(result?.id);
          }
        } else {
          if (context.mounted) {
            print('ĐẶT XE CHO NGƯỜI TA');
            result = await ref
                .read(tripControllerProvider.notifier)
                .findDriverForDependent(
                  context,
                  FindTripModel(
                    startLatitude: double.parse(widget.startLatitude),
                    startLongitude: double.parse(widget.startLongitude),
                    //startAddress: 'Nha Nguyen',
                    endLatitude: double.parse(widget.endLatitude),
                    endLongitude: double.parse(widget.endLongitude),
                    //endAddress: 'Nga 3',
                    cartypeId: widget.carTypeId,
                    paymentMethod: int.parse(widget.paymentMethod),
                  ),
                  widget.bookerId,
                );
          }

          if (result != null) {
            ref
                .read(currentDependentOnTripProvider.notifier)
                .addDependentCurrentOnTripId(
                  DependentTrip(
                      id: result!.id,
                      name: result!.passenger.name,
                      dependentId: result!.passenger.id),
                );
          }
        }
        // Use setState to trigger a rebuild of the widget with the new data.
        setState(() {
          _isLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    //revokeHub();
    _controller?.onDispose();
    super.dispose();
  }

  void revokeHub() async {
    final hubConnection = await ref.read(
      hubConnectionProvider.future,
    );
    hubConnection.off('NotifyPassengerTripCanceled');
    hubConnection.off('NotifyPassengerDriverOnTheWay');
    hubConnection.off('NotifyPassengerTripTimedOut');
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
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on('NotifyPassengerDriverOnTheWay', (message) {
        try {
          // setState(() {
          //   _isLoading = true;
          // });
          // await Future.delayed(
          //   const Duration(seconds: 1),
          // );
          // setState(() {
          //   _isLoading = false;
          // });
          if (mounted) {
            HapticFeedback.mediumImpact();
            _handleNotifyPassengerDriverOnTheWay(message);
          }
        } catch (e) {
          print(e.toString());
        }
      });
      hubConnection.on('NotifyPassengerTripCanceled', (message) {
        try {
          // setState(() {
          //   _isLoading = true;
          // });
          // await Future.delayed(
          //   const Duration(seconds: 2),
          // );
          // setState(() {
          //   _isLoading = false;
          // });
          if (mounted) {
            _handleNotifyPassengerTripCanceled(message);
          }
        } catch (e) {
          print(e.toString());
        }
      });
      hubConnection.on('NotifyPassengerTripTimedOut', (message) {
        try {
          if (mounted) {
            _handleNotifyPassengerTripTimedOut(message);
          }
          //_handleNotifyPassengerDriverOnTheWay(message);
        } catch (e) {
          print(e.toString());
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
      rethrow;
    }
  }

  void _handleNotifyPassengerDriverOnTheWay(dynamic message) {
    final driverData =
        (message as List<dynamic>).cast<Map<String, dynamic>>().first;

    setState(() {
      driverName = driverData['name'];
      driverId = driverData['id'];
      driverPhone = driverData['phone'];
      driverAvatar = driverData['avatarUrl'];
      driverPlate = driverData['car']['licensePlate'];
      driverCarType =
          driverData['car']['model'] + " " + driverData['car']['make'];
    });

    _showDriverInfoDialog();
  }

  void _handleNotifyPassengerTripTimedOut(dynamic message) {
    _showFindTripTimeOutDialog();
  }

  void _handleNotifyPassengerTripCanceled(dynamic message) {
    print('bên trong handle data');
    final data = message as List<dynamic>;
    final tripData = data.cast<Map<String, dynamic>>().first;
    final trip = TripModel.fromMap(tripData);
    bool isSelfBook = data.cast<bool>()[1];
    //bool isNotifyToGuardian = data.cast<bool>()[2];
    if (isSelfBook == false) {
      _showCanceledTripDialog(trip);
    }
  }

  void _showDriverInfoDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Đã tìm thấy tài xế',
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0),
            child: Row(
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
                Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                      driverAvatar,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // setState(() {
                //   _isLoading = true;
                // });
                // await Future.delayed(
                //   const Duration(seconds: 2),
                // );
                // setState(() {
                //   _isLoading = false;
                // });
                navigateToDriverPickupScreen(
                  driverName,
                  driverCarType,
                  driverPlate,
                  driverPhone,
                  driverAvatar,
                  driverId,
                  widget.endLatitude,
                  widget.endLongitude,
                );
              },
              child: const Text(
                'Xác nhận',
              ),
            ),
          ],
        );
      },
    ).then((value) {
      // setState(() {
      //   _isLoading = true;
      // });
      // await Future.delayed(
      //   const Duration(seconds: 2),
      // );
      // setState(() {
      //   _isLoading = false;
      // });
      navigateToDriverPickupScreen(
        driverName,
        driverCarType,
        driverPlate,
        driverPhone,
        driverAvatar,
        driverId,
        widget.endLatitude,
        widget.endLongitude,
      );
    });
  }

  void _showFindTripTimeOutDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Thời gian tìm xe đã hết',
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Đã quá hạn tìm xe mà chúng tôi không tìm được tài xế cho bạn. Vui lòng thử lại')
                    ],
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                      driverAvatar,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await Future.delayed(
                  const Duration(seconds: 2),
                );
                setState(() {
                  _isLoading = false;
                });
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

  void _showCanceledTripDialog(TripModel trip) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Thời gian tìm xe đã hết',
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Đã quá hạn tìm xe mà chúng tôi không tìm được tài xế cho bạn. Vui lòng thử lại')
                    ],
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                      driverAvatar,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // setState(() {
                //   _isLoading = true;
                // });
                // await Future.delayed(
                //   const Duration(seconds: 2),
                // );
                // setState(() {
                //   _isLoading = false;
                // });
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

  void navigateToDriverPickupScreen(
    String driverName,
    String driverCarType,
    String driverPlate,
    String driverPhone,
    String driverAvatar,
    String driverId,
    String endLatitude,
    String endLongitude,
  ) {
    context.replaceNamed(RouteConstants.driverPickUp, extra: {
      'driverName': driverName,
      'driverCarType': driverCarType,
      'driverPlate': driverPlate,
      'driverPhone': driverPhone,
      'driverAvatar': driverAvatar,
      'driverId': driverId,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
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
        height: MediaQuery.of(context).size.height * .2,
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
                //CircularProgressIndicator(),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: ElevatedButton(
                onPressed: () async {
                  if (result != null) {
                    if (result!.id.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      final check = await ref
                          .watch(tripControllerProvider.notifier)
                          .cancelTrip(
                            context,
                            result!.id,
                          );
                      setState(() {
                        _isLoading = false;
                      });
                      if (check) {
                        if (context.mounted) {
                          setState(() {
                            ref
                                .watch(currentOnTripIdProvider.notifier)
                                .setCurrentOnTripId(null);
                          });
                          context.goNamed(RouteConstants.dashBoard);
                        }
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
              //onMapMove: () => _showRecenterButton(),
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
                wayPoints.clear();
                wayPoints.add(
                  WayPoint(
                    name: 'origin point',
                    latitude: double.parse(widget.startLatitude),
                    longitude: double.parse(widget.startLongitude),
                  ),
                );
                wayPoints.add(
                  WayPoint(
                    name: 'destination point',
                    latitude: double.parse(widget.endLatitude),
                    longitude: double.parse(widget.endLongitude),
                  ),
                );
                _controller?.addImageMarkers([
                  Marker(
                    imagePath: 'assets/download.png',
                    latLng: LatLng(
                      double.parse(widget.endLatitude),
                      double.parse(widget.endLongitude),
                    ),
                  ),
                ]);
                _controller?.buildRoute(wayPoints: wayPoints);
                // _controller?.buildAndStartNavigation(
                //   wayPoints: wayPoints,
                // );
              },
              // onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
              //   setState(() {
              //     this.routeProgressEvent = routeProgressEvent;
              //   });
              //   _setInstructionImage(routeProgressEvent.currentModifier,
              //       routeProgressEvent.currentModifierType);
              // },
            ),
            _isRunning && _isRouteBuilt
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
                              if (result != null) {
                                if (result!.id.isNotEmpty) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final check = await ref
                                      .watch(tripControllerProvider.notifier)
                                      .cancelTrip(
                                        context,
                                        result!.id,
                                      );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (check) {
                                    if (context.mounted) {
                                      setState(() {
                                        ref
                                            .watch(currentOnTripIdProvider
                                                .notifier)
                                            .setCurrentOnTripId(null);
                                      });
                                      context.goNamed(RouteConstants.dashBoard);
                                    }
                                  }
                                }
                              }

                              if (context.mounted) {
                                context.goNamed(RouteConstants.dashBoard);
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

  // _showRecenterButton() {
  //   recenterButton = TextButton(
  //       onPressed: () {
  //         _controller?.recenter();
  //         setState(() {
  //           recenterButton = const SizedBox.shrink();
  //         });
  //       },
  //       child: Container(
  //           height: 50,
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(50),
  //               color: Colors.white,
  //               border: Border.all(color: Colors.black45, width: 1)),
  //           child: const Row(
  //             children: [
  //               Icon(
  //                 Icons.keyboard_double_arrow_up_sharp,
  //                 color: Colors.lightBlue,
  //                 size: 35,
  //               ),
  //               Text(
  //                 'Về giữa',
  //                 style: TextStyle(fontSize: 18, color: Colors.lightBlue),
  //               )
  //             ],
  //           )));
  //   setState(() {});
  // }

  // _setInstructionImage(String? modifier, String? type) {
  //   if (modifier != null && type != null) {
  //     List<String> data = [
  //       type.replaceAll(' ', '_'),
  //       modifier.replaceAll(' ', '_')
  //     ];
  //     String path = 'assets/navigation_symbol/${data.join('_')}.svg';
  //     setState(() {
  //       instructionImage = SvgPicture.asset(path, color: Colors.white);
  //     });
  //   }
  // }

  // _onStopNavigation() {
  //   setState(() {
  //     routeProgressEvent = null;
  //     _isRunning = false;
  //   });
  // }

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
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/models/user_data_model.dart';
import 'package:goshare/models/vietmap_route_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:signalr_core/signalr_core.dart';

import 'package:goshare/providers/signalr_providers.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

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
  final String? nonAppDepName;
  final String? nonAppDepPhone;
  const FindTripScreen2({
    super.key,
    this.driverNote,
    this.nonAppDepName,
    this.nonAppDepPhone,
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
  VietmapController? _controller;
  UserLocation? userLocation;
  PolylinePoints polylinePoints = PolylinePoints();
  VietMapRouteModel? routeModel;
  List<Marker> temp = [];

  // Widget instructionImage = const SizedBox.shrink();
  // String guideDirection = "";
  // Widget recenterButton = const SizedBox.shrink();
  bool _isRouteBuilt = false;
  FocusNode focusNode = FocusNode();
  bool _isLoading = false;
  String driverName = '';
  String driverPhone = '';
  String driverAvatar = '';
  String driverPlate = '';
  String driverCarType = '';
  String driverId = '';
  String startAddress = '';
  String endAddress = '';
  @override
  void initState() {
    // _showDriverInfoDialog();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          _isLoading = true;
        });
        await initSignalR(ref);
        await setAddress();
        if (mounted) {
          print('START ADDRESS: $startAddress');
          print('END ADDRESS: $endAddress');
          print('TEN NGUOI DAT DUM: ${widget.nonAppDepName}');
          if (widget.nonAppDepName != null) {
            print("TÌM XE CHO DEP KHÔNG CÓ LOCATIONNNNNNNNNNNNNNNNNN");
            if (mounted) {
              result = await ref
                  .read(tripControllerProvider.notifier)
                  .findDriverForNonAppDependent(
                    context,
                    FindTripNonAppModel(
                      startLatitude: double.parse(widget.startLatitude),
                      startLongitude: double.parse(widget.startLongitude),
                      startAddress: startAddress,
                      endLatitude: double.parse(widget.endLatitude),
                      endLongitude: double.parse(widget.endLongitude),
                      endAddress: endAddress,
                      cartypeId: widget.carTypeId,
                      paymentMethod: int.parse(widget.paymentMethod),
                      note: widget.driverNote,
                      dependentInfo: DependentInfo(
                        phone: widget.nonAppDepPhone,
                        name: widget.nonAppDepName ?? '',
                      ),
                    ),
                  );
              if (result != null) {
                ref
                    .read(currentDependentOnTripProvider.notifier)
                    .addDependentCurrentOnTripId(
                      DependentTrip(
                        id: result!.id,
                        name: result!.passengerName,
                        dependentId: result!.passengerId,
                      ),
                    );
              }
            }
          } else {
            if (widget.bookerId == ref.read(userProvider.notifier).state?.id) {
              if (context.mounted) {
                print("TÌM XE CHO BẢN THÂN");
                result =
                    await ref.read(tripControllerProvider.notifier).findDriver(
                          context,
                          FindTripModel(
                            startLatitude: double.parse(widget.startLatitude),
                            startLongitude: double.parse(widget.startLongitude),
                            startAddress: startAddress,
                            endLatitude: double.parse(widget.endLatitude),
                            endLongitude: double.parse(widget.endLongitude),
                            endAddress: endAddress,
                            cartypeId: widget.carTypeId,
                            paymentMethod: int.parse(widget.paymentMethod),
                            note: widget.driverNote,
                          ),
                        );

                if (result != null) {
                  ref
                      .read(currentOnTripIdProvider.notifier)
                      .setCurrentOnTripId(result?.id);
                }
              }
            } else {
              if (context.mounted) {
                result = await ref
                    .read(tripControllerProvider.notifier)
                    .findDriverForDependent(
                      context,
                      FindTripModel(
                        startLatitude: double.parse(widget.startLatitude),
                        startLongitude: double.parse(widget.startLongitude),
                        startAddress: startAddress,
                        endLatitude: double.parse(widget.endLatitude),
                        endLongitude: double.parse(widget.endLongitude),
                        endAddress: endAddress,
                        cartypeId: widget.carTypeId,
                        paymentMethod: int.parse(widget.paymentMethod),
                        note: widget.driverNote,
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
          }
        }
        // Use setState to trigger a rebuild of the widget with the new data.
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e.toString());
      }
    });

    super.initState();
  }

  Future<void> setAddress() async {
    final data =
        await ref.watch(homeControllerProvider.notifier).searchLocationReverse(
              context,
              double.parse(widget.startLongitude),
              double.parse(widget.startLatitude),
            );
    startAddress = data.address ?? '';
    if (mounted) {
      final data2 = await ref
          .watch(homeControllerProvider.notifier)
          .searchLocationReverse(
            context,
            double.parse(widget.endLongitude),
            double.parse(widget.endLatitude),
          );
      endAddress = data2.address ?? '';
      setState(() {});
    }
  }

  @override
  void dispose() {
    //revokeHub();
    _controller?.dispose();
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

  //MapOptions? options;

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on('NotifyPassengerDriverOnTheWay', (message) {
        print("ĐÂY RỒI SIGNALR ĐÂY RỒI $message");
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
            //HapticFeedback.mediumImpact();
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
    if (mounted) {
      _showDriverInfoDialog();
    }
  }

  void _handleNotifyPassengerTripTimedOut(dynamic message) {
    if (mounted) {
      _showFindTripTimeOutDialog();
    }
  }

  void _handleNotifyPassengerTripCanceled(dynamic message) {
    print('bên trong handle data');
    final data = message as List<dynamic>;
    final tripData = data.cast<Map<String, dynamic>>().first;
    final trip = TripModel.fromMap(tripData);
    bool isSelfBook = data.cast<bool>()[1];
    //bool isNotifyToGuardian = data.cast<bool>()[2];
    if (isSelfBook == false) {
      if (mounted) {
        _showCanceledTripDialog(trip);
      }
    }
  }

  void _showDriverInfoDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext abcContext) {
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
                Navigator.of(abcContext).pop();
                navigateToDriverPickupScreen(
                  driverName,
                  driverCarType,
                  driverPlate,
                  driverPhone,
                  driverAvatar,
                  driverId,
                  widget.endLatitude,
                  widget.endLongitude,
                  widget.startLatitude,
                  widget.startLongitude,
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
      // navigateToDriverPickupScreen(
      //   driverName,
      //   driverCarType,
      //   driverPlate,
      //   driverPhone,
      //   driverAvatar,
      //   driverId,
      //   widget.endLatitude,
      //   widget.endLongitude,
      // );
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Đã quá hạn tìm xe mà chúng tôi không tìm được tài xế cho bạn. Vui lòng thử lại',
                      )
                    ],
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

  void _showCanceledTripDialog(TripModel trip) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Chuyến xe đã bị hủy',
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
                        'Chuyến xe bạn tìm đã bị hủy.',
                      )
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
                Navigator.of(dialogContext).pop();
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
    String startLatitude,
    String startLongitude,
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
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
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
              width: MediaQuery.of(context).size.width * .3,
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
                          if (ref.watch(userProvider)?.id ==
                              result!.passengerId) {
                            ref
                                .watch(currentOnTripIdProvider.notifier)
                                .setCurrentOnTripId(null);
                          } else {
                            ref
                                .watch(currentDependentOnTripProvider.notifier)
                                .removeDependentCurrentOnTripId(result!.id);
                          }

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
            // NavigationView(
            //   mapOptions: _navigationOption,
            //   onNewRouteSelected: (p0) {
            //     print(p0.toString());
            //   },
            //   onMapCreated: (p0) async {
            //     _controller = p0;
            //   },
            //   //onMapMove: () => _showRecenterButton(),
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
            //     _controller?.buildRoute(wayPoints: wayPoints);
            //     // _controller?.buildAndStartNavigation(
            //     //   wayPoints: wayPoints,
            //     // );
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
                                      if (ref.watch(userProvider)?.id ==
                                          result!.passengerId) {
                                        ref
                                            .watch(currentOnTripIdProvider
                                                .notifier)
                                            .setCurrentOnTripId(null);
                                      } else {
                                        ref
                                            .watch(
                                                currentDependentOnTripProvider
                                                    .notifier)
                                            .removeDependentCurrentOnTripId(
                                                result!.id);
                                      }
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
}

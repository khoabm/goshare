import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/dependent_mng/dependent_screen.dart';
import 'package:goshare/features/home/screen/dependent_screen.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/login/controller/log_in_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';

import 'package:goshare/features/menu_user/menu-user-screen.dart';

import 'package:goshare/features/trip/screens/car_choosing_screen.dart';
import 'package:goshare/features/trip_history/trip_history_screen.dart';
import 'package:goshare/models/trip_model.dart';

import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';
import 'package:goshare/providers/dependent_trip_provider.dart';

import 'package:goshare/providers/signalr_providers.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:signalr_core/signalr_core.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  int _currentIndex = 0;

  bool _isLoading = false;
  final List<Widget> _children = [
    const HomeScreen(),
    const TripHistoryScreen(),
    const DependentScreen(),
    const UserMenuPage(),
  ];
  final List<Widget> _children_Dependent = [
    const DependentHomeScreen(),
    const UserMenuPage(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool isDependent = false;

  @override
  void initState() {
    if (!mounted) return;
    final user = ref.read(userProvider);
    isDependent = user?.role.toLowerCase() == 'dependent';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          _isLoading = true;
        });
        await initSignalR(ref);
        final isFcmTokenUpdated =
            await ref.read(LoginControllerProvider.notifier).updateFcmToken();
        if (isFcmTokenUpdated) {
          print('fcmToken updated');
        } else {
          print('fcmTokenError');
        }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  Future<void> initSignalR(WidgetRef ref) async {
    if (mounted) {
      final connection = await ref.read(
        hubConnectionProvider.future,
      );

      if (connection.state == HubConnectionState.disconnected) {
        await connection.start()?.then((value) {
          print('Start thanh cong');
          print(connection.baseUrl);

          //HubConnection._handshakeProtocol;
        }).catchError((error) {
          print('Error: $error');
        });
      }

      final locationPro = ref.read(locationProvider);
      final user = ref.read(userProvider.notifier).state;
      if (user?.role.toLowerCase() == 'dependent') {
        connection.on("RequestLocation", (message) async {
          final currentLocation = await locationPro.getCurrentLocation();
          final location = {
            "latitude": currentLocation?.latitude,
            "longitude":
                currentLocation?.longitude, // Replace with the actual longitude
            "address": "" // Replace with the actual address
          };

          connection.invoke(
            "SendLocation",
            args: <Object>[
              user!.id,
              jsonEncode(location),
            ],
          ).then((value) {
            print("Location sent to server - in dashboard: $location");
          }).catchError((error) {
            print("Error sending location to server: $error");
          });
        });

        connection.on(
          'NotifyDependentNewTripBooked',
          (arguments) {
            try {
              if (mounted) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  final tripData = (arguments as List<dynamic>)
                      .cast<Map<String, dynamic>>()
                      .first;
                  final trip = TripModel.fromMap(tripData);
                  ref.read(tripProvider.notifier).setTripData(tripData);
                  ref.read(stageProvider.notifier).setStage(
                        Stage.stage1,
                      );
                  if (mounted) {
                    showDialogInfo(trip, context, ref);
                  }
                }
              }
            } catch (e) {
              print("Error in SignalR callback: $e");
            }
          },
        );
      }

      connection.on(
        'NotifyPassengerTripCanceled',
        (arguments) {
          try {
            if (mounted) {
              print('TRIP CANCEL');
              final data = arguments as List<dynamic>;
              final tripData = data.cast<Map<String, dynamic>>().first;
              final trip = TripModel.fromMap(tripData);
              bool isSelfBook = data.cast<bool>()[1];
              bool isNotifyToGuardian = data.cast<bool>()[2];
              bool isCanceledByAdmin = data.cast<bool>()[3];
              if (isSelfBook == false) {
                if (isNotifyToGuardian == false) {
                  ref.read(stageProvider.notifier).setStage(
                        Stage.stage0,
                      );
                  showCancelDialogInfo(trip, context, ref);
                }
                if (isCanceledByAdmin == true) {
                  if (mounted) {
                    print('CANCEL ADMIN TRIP ĐẶT DÙM');
                    if (trip.type == 0) {
                      ref
                          .read(currentOnTripIdProvider.notifier)
                          .setCurrentOnTripId(null);
                    } else if (trip.type == 1) {
                      ref.read(stageProvider.notifier).setStage(
                            Stage.stage0,
                          );
                    }
                    context.goNamed(RouteConstants.dashBoard);
                    showAdminCancelDialogInfo(context);
                  }
                }
              }
            }
          } catch (e) {
            print("Error in SignalR callback: $e");
          }
        },
      );

      connection.on(
        'NotifyPassengerDriverOnTheWay',
        (message) {
          try {
            if (mounted) {
              print("THE DRIVER IS ON THE WAY");
              if (ModalRoute.of(context)?.isCurrent ?? false) {
                final driverData = (message as List<dynamic>)
                    .cast<Map<String, dynamic>>()
                    .first;
                bool isSelfBook = message.cast<bool>()[1];
                bool isNotifyToGuardian = message.cast<bool>()[2];
                if (isSelfBook == false) {
                  if (isNotifyToGuardian == false) {
                    final driver = Driver.fromMap(driverData);
                    ref.read(driverProvider.notifier).addDriverData(driver);
                    ref.read(stageProvider.notifier).setStage(
                          Stage.stage2,
                        );
                  }
                } else {}
              }
            }
          } catch (e) {
            print(
              e.toString(),
            );
          }
        },
      );

      connection.on(
        'NotifyPassengerDriverPickup',
        (message) {
          try {
            if (mounted) {
              print('DRIVER PICK UP');
              if (ModalRoute.of(context)?.isCurrent ?? false) {
                final data = message as List<dynamic>;
                final tripData = data.cast<Map<String, dynamic>>().first;

                final trip = TripModel.fromMap(tripData);
                bool isSelfBook = data.cast<bool>()[1];
                bool isNotifyToGuardian = data.cast<bool>()[2];

                if (isSelfBook == false) {
                  if (isNotifyToGuardian == false) {
                    ref.read(stageProvider.notifier).setStage(
                          Stage.stage3,
                        );
                    showDialogInfoPickUpV2(
                      trip,
                      context,
                    );
                  }
                }
              }
            }
          } catch (e) {
            print(
              e.toString(),
            );
            rethrow;
          }
        },
      );

      connection.on(
        'NotifyPassengerTripEnded',
        (message) {
          try {
            if (mounted) {
              if (ModalRoute.of(context)?.isCurrent ?? false) {
                print('ON TRIP ENDED DASHBOARD');
                final data = message as List<dynamic>;
                final tripData = data.cast<Map<String, dynamic>>().first;
                final trip = TripModel.fromMap(tripData);
                bool isSelfBook = data.cast<bool>()[1];
                bool isNotifyToGuardian = data.cast<bool>()[2];
                ref
                    .read(currentOnTripIdProvider.notifier)
                    .setCurrentOnTripId(null);
                if (isSelfBook == true) {
                  ref
                      .read(currentOnTripIdProvider.notifier)
                      .setCurrentOnTripId(null);
                  context.pushNamed(RouteConstants.rating, pathParameters: {
                    'idTrip': trip.id,
                  });
                } else {
                  if (isNotifyToGuardian == false) {
                    ref.read(stageProvider.notifier).setStage(Stage.stage0);
                    context.pushNamed(
                      RouteConstants.rating,
                      pathParameters: {
                        'idTrip': trip.id,
                      },
                    );
                  } else {
                    ref
                        .watch(currentDependentOnTripProvider.notifier)
                        .removeDependentCurrentOnTripId(trip.id);
                    showNavigateDashBoardDialog(trip, context);
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
      connection.onreconnected((connectionId) async {
        print('reconnected $connectionId');
        showSnackBar(context: context, message: 'Đã kết nối lại');
      });
      connection.onreconnecting((exception) {
        print(exception.toString());
        print('reconnecting');
        showSnackBar(context: context, message: 'Đang kết nối lại');
      });
      connection.onclose(
        (exception) async {
          print('LOI SIGNALR CONNECTION DASHBOARD');
          print(
            exception.toString(),
          );
          if (connection.state == HubConnectionState.disconnected) {
            await Future.delayed(
              const Duration(seconds: 3),
              () async {
                await connection.start()?.then((value) {
                  print('Start thanh cong');
                  print(connection.baseUrl);
                });
              },
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToFindTrip(TripModel trip) {
    context.goNamed(RouteConstants.findTrip, extra: {
      'startLatitude': trip.startLocation.latitude,
      'startLongitude': trip.startLocation.longitude,
      'endLatitude': trip.endLocation.latitude,
      'endLongitude': trip.endLocation.longitude,
      'paymentMethod': trip.paymentMethod.toString(),
      'bookerId': trip.bookerId,
      'carTypeId': trip.cartypeId,
      'driverNote': trip.note,
      'isFindingTrip': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems;
    if (isDependent) {
      bottomNavItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            IconData(
              0xf74d,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
          ),
          label: 'Tài khoản',
        ),
      ];
    } else {
      bottomNavItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: 'Lịch sử',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Người phụ thuộc',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            IconData(
              0xf74d,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
          ),
          label: 'Tài khoản',
        ),
      ];
    }

    //ref.watch(locationProvider);
    print('TestWidget: ${ModalRoute.of(context)?.isCurrent}');
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const Loader()
            : isDependent
                ? _children_Dependent[_currentIndex]
                : _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Pallete.primaryColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: bottomNavItems,
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/login/controller/log_in_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';

import 'package:goshare/features/menu_user/menu-user-screen.dart';

import 'package:goshare/features/trip/screens/car_choosing_screen.dart';
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

    // const GuardianObserveDependentTripScreen(

    // ),
    CarChoosingScreen(
      startLongitude: "106.8006742",
      startLatitude: "10.8756434",
      endLongitude: "106.748967",
      endLatitude: "10.682559",
    ), //Text('Second screen'),
    //Text('Second screen'),
    // const Center(
    //   child: Text(
    //     'hehe',
    //     style: TextStyle(color: Colors.white),
    //   ),
    // ),
    const UserMenuPage(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!mounted) return;
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

  // void initSignalR() async {

  // }

  Future<void> initSignalR(WidgetRef ref) async {
    if (mounted) {
      final connection = await ref.read(
        hubConnectionProvider.future,
      );
      if (connection.state == HubConnectionState.disconnected) {
        await connection.start()?.then(
              (value) => {
                print('Start thanh cong'),
              },
            );
      }

      final location = ref.read(locationProvider);
      final user = ref.read(userProvider.notifier).state;
      if (user?.role.toLowerCase() == 'dependent') {
        final currentLocation = await location.getCurrentLocation();
        connection.on("RequestLocation", (message) {
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
            print("Location sent to server: $location");
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
        connection.on(
          'NotifyPassengerTripCanceled',
          (arguments) {
            try {
              if (mounted) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  final data = arguments as List<dynamic>;
                  final tripData = data.cast<Map<String, dynamic>>().first;
                  final trip = TripModel.fromMap(tripData);
                  bool isSelfBook = data.cast<bool>()[1];
                  bool isNotifyToGuardian = data.cast<bool>()[2];
                  if (isSelfBook == false) {
                    if (isNotifyToGuardian == false) {
                      showDialogInfo(trip, context, ref);
                    }
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
        'NotifyPassengerDriverOnTheWay',
        (message) {
          try {
            if (mounted) {
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
              if (ModalRoute.of(context)?.isCurrent ?? false) {
                final data = message as List<dynamic>;
                final tripData = data.cast<Map<String, dynamic>>().first;
                final trip = TripModel.fromMap(tripData);
                bool isSelfBook = data.cast<bool>()[1];
                bool isNotifyToGuardian = data.cast<bool>()[2];

                if (isSelfBook == false) {
                  if (isNotifyToGuardian == false) {
                    showDialogInfoPickUp(
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
                  context.replaceNamed(RouteConstants.rating);
                } else {
                  if (isNotifyToGuardian == false) {
                    ref.read(stageProvider.notifier).setStage(Stage.stage0);
                    context.replaceNamed(RouteConstants.rating);
                  } else {
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

      connection.onclose(
        (exception) {
          print(
            exception.toString(),
          );
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
    //ref.watch(locationProvider);
    print('TestWidget: ${ModalRoute.of(context)?.isCurrent}');
    return Scaffold(
      body: Center(
        child: _isLoading ? const Loader() : _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.primaryColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(
                0xf74d,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
            ),
            label: 'Account',
          )
        ],
      ),
    );
  }
}

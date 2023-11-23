import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/locations_util.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/login/controller/log_in_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';

import 'package:goshare/features/menu_user/menu-user-screen.dart';

import 'package:goshare/features/trip/controller/trip_controller.dart';

import 'package:goshare/features/trip/screens/car_choosing_screen.dart';
import 'package:goshare/models/trip_model.dart';

import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';

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
  int _stage = 0;
  bool _isLoading = false;
  final List<Widget> _children = [
    const HomeScreen(),
    const CarChoosingScreen(
      startLongitude: "106.8006742",
      startLatitude: "10.8756434",
      endLongitude: "106.748967",
      endLatitude: "10.682559",
    ), //Text('Second screen'),
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
        final connection = await ref.watch(
          hubConnectionProvider.future,
        );
        final location = ref.read(locationProvider);
        final user = ref.watch(userProvider.notifier).state;
        if (user?.role.toLowerCase() == 'dependent') {
          final currentLocation = await location.getCurrentLocation();
          connection.on("RequestLocation", (message) {
            print('hehehehehe GET LOCATION DEP');
            final location = {
              "latitude": currentLocation?.latitude,
              "longitude": currentLocation
                  ?.longitude, // Replace with the actual longitude
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
              print("SIGNAL R DEP TRIP BOOK" + arguments.toString());
              final tripData = (arguments as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .first;
              final trip = TripModel.fromJson(tripData);
              ref.watch(stageProvider.notifier).setStage(
                    Stage.stage1,
                  );
              showDialogInfo(trip);
              //navigateToFindTrip(trip);
            },
          );
        }
        connection.on('NotifyPassengerTripEnded', (message) {
          print(" DAY ROI SIGNAL R DAY ROI ${message.toString()}");
          setState(() {
            ref
                .watch(currentOnTripIdProvider.notifier)
                .setCurrentOnTripId(null);
          });
        });
        if (connection.state == HubConnectionState.disconnected) {
          await connection.start()?.then(
                (value) => {
                  print('Start thanh cong'),
                },
              );
        }

        connection.onclose(
          (exception) {
            print(
              exception.toString(),
            );
          },
        );
        final isFcmTokenUpdated =
            await ref.watch(LoginControllerProvider.notifier).updateFcmToken();
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

  void showDialogInfo(TripModel? trip) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Anh/chị ${trip?.booker?.name} đang tìm xe cho bạn',
            ),
          ),
          content: const SizedBox.shrink(),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'Xác nhận',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.watch(tripControllerProvider.notifier).cancelTrip(
                      context,
                      trip?.id ?? '',
                    );
              },
              child: const Text(
                'Hủy',
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToFindTrip(TripModel trip) {
    context.replaceNamed(RouteConstants.findTrip, extra: {
      'startLatitude': trip.startLocation?.latitude,
      'startLongitude': trip.startLocation?.longitude,
      'endLatitude': trip.endLocation?.latitude,
      'endLongitude': trip.endLocation?.longitude,
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

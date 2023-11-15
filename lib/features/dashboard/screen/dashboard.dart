import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/search_trip_route/screens/car_choosing_screen.dart';
import 'package:goshare/features/search_trip_route/screens/find_trip_screen.dart';
import 'package:goshare/providers/current_location_provider.dart';
import 'package:goshare/providers/signalr_providers.dart';
import 'package:goshare/theme/pallet.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
    const CarChoosingScreen(
      startLongitude: "0",
      startLatitude: "0",
      endLongitude: "0",
      endLatitude: "0",
    ), //Text('Second screen'),
    const Text('Profile'),
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
        final hubConnection = ref.watch(
          hubConnectionProvider,
        );
        await hubConnection.start()?.then(
              (value) => {
                print('Start thanh cong'),
              },
            );
        hubConnection.onclose((exception) {
          print(
            exception.toString(),
          );
        });
      } catch (e) {
        print(e.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(locationProvider);
    return Scaffold(
      body: Center(
        child: _children[_currentIndex],
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

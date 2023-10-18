import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/locations_util.dart';
import 'package:goshare/features/home/repositories/home_repository.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:location/location.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
  }

  // void getCurrentLocation() async {
  //   final locationUtils = ref.read(locationProvider);
  //   LocationData? data = await locationUtils.getCurrentLocation();
  //   if (mounted) {
  //     setState(() {
  //       locationData = data;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final homeRepository = ref.read(homeRepositoryProvider);

    return Scaffold(
      //appBar: AppBar(title: const Text('Home Screen')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    width: MediaQuery.of(context)
                        .size
                        .width, // This will take the full width of your screen
                    height: MediaQuery.of(context).size.height * .3,
                    child: SvgPicture.asset(
                      Constants.carBanner,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .05,
                    left: MediaQuery.of(context).size.width * .1,
                    child: Text(
                      'Chào Khải, \n${homeRepository.greeting()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              HomeCenterContainer(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .3,
                verticalPadding: 12.0,
                horizontalPadding: 12.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn muốn đi đến đâu ?',
                      style: TextStyle(
                        color: Pallete.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        8.0,
                      ),
                      width: 200, // adjust width as needed
                      height: 60, // adjust height as needed
                      child: AppButton(
                        buttonText: 'Nhà',
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        8.0,
                      ),
                      width: 200, // adjust width as needed
                      height: 60,
                      child: AppButton(
                        buttonText: 'Nơi làm việc',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // HomeCenterContainer(
              //   width: MediaQuery.of(context).size.width * .9,
              //   height: MediaQuery.of(context).size.height * .45,
              //   verticalPadding: 12.0,
              //   horizontalPadding: 12.0,
              //   child: locationData == null
              //       ? const Loader()
              //       : Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             const Text(
              //               'Địa chỉ nơi làm việc',
              //               style: TextStyle(
              //                 color: Pallete.primaryColor,
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             Expanded(
              //               child: GoogleMap(

              //                 zoomControlsEnabled: false,
              //                 zoomGesturesEnabled: false,
              //                 scrollGesturesEnabled: false,
              //                 tiltGesturesEnabled: false,
              //                 rotateGesturesEnabled: false,
              //                 initialCameraPosition: CameraPosition(
              //                   zoom: 18.5,
              //                   target: LatLng(
              //                     locationData!.latitude!,
              //                     locationData!.longitude!,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              // ),
              // const SizedBox(
              //   height: 40,
              // ),
              HomeCenterContainer(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .12,
                verticalPadding: 8.0,
                horizontalPadding: 6.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(),
                        Text(
                          'GoShare hotline \n 1900xxxx',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Giúp chúng tôi cải thiện',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppButton(
                          buttonText: 'Đóng góp',
                          fontSize: 16,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

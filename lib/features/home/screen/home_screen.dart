import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/features/home/delegates/search_places_delegate.dart';
import 'package:goshare/features/home/repositories/home_repository.dart';
import 'package:goshare/features/home/widgets/home_tab_bar.dart';
import 'package:goshare/providers/current_location_provider.dart';
import 'package:goshare/theme/pallet.dart';

class CustomSearchBar extends StatelessWidget {
  final Function onTap;
  const CustomSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            7,
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              color: Pallete.primaryColor,
            ),
            SizedBox(width: 8),
            Text(
              '|',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Tìm kiếm bất kì địa chỉ nào',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //LocationData? locationData;
  final searchPlaceTextController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();

    // getCurrentLocation();
  }

  @override
  void dispose() {
    searchPlaceTextController.dispose();
    super.dispose();
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
  void navigateToSearchTripRoute(BuildContext context) {
    context.pushNamed('search-trip-route');
  }

  @override
  Widget build(BuildContext context) {
    final locationAsyncValue = ref.watch(locationStreamProvider);
    final homeRepository = ref.read(homeRepositoryProvider);
    // final location = ref.watch(locationProvider).currentLocation;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomSearchBar(onTap: () {
              navigateToSearchTripRoute(context);
              // showSearch(
              //   context: context,
              //   delegate: SearchPlacesDelegate(ref),
              // );
            }),
          ),
          // IconButton(
          //   onPressed: () {
          //     showSearch(
          //       context: context,
          //       delegate: SearchPlacesDelegate(ref),
          //     );
          //   },
          //   icon: const Icon(Icons.search),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              locationAsyncValue.when(
                data: (locationData) {
                  final longitude = locationData.longitude;
                  final latitude = locationData.latitude;
                  // Use longitude and latitude here
                  return Text(
                    'Longitude: $longitude, Latitude: $latitude',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                },
                error: (_, __) => const Text(
                  'Failed to load location',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                loading: () => const Text(
                  'loading',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
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
              const HomeTabBar(),
              const SizedBox(
                height: 20,
              ),
              HomeCenterContainer(
                width: MediaQuery.of(context).size.width * .9,
                //height: MediaQuery.of(context).size.height * .12,
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

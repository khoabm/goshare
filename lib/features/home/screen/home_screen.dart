import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/locations_util.dart';
import 'package:goshare/features/home/repositories/home_repository.dart';
// import 'package:goshare/features/home/widgets/home_tab_bar.dart';
import 'package:goshare/features/home/widgets/location_card.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/features/trip/screens/car_choosing_screen.dart';

import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/dependent_model.dart';
// import 'package:goshare/providers/current_location_provider.dart';
// import 'package:goshare/providers/current_location_provider.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:intl/intl.dart';

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
  // LocationData? locationData;
  // final location = Location();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToSearchTripRoute(BuildContext context) {
    context.pushNamed(RouteConstants.searchTripRoute);
  }

  Future<DependentModel?> navigateToDependentList(BuildContext context) async {
    DependentModel? dependent = await context.pushNamed('dependent-list');
    return dependent;
  }

  void _showBottomModal(
    double? latitude,
    double? longitude,
    WidgetRef ref,
  ) async {
    try {
      print('hehehe');

      final oCcy = NumberFormat("#,##0", "vi_VN");
      setState(() {
        _isLoading = true;
      });
      final location = ref.watch(locationProvider);
      final currentLocation = await location.getCurrentLocation();

      print('hehehehe');
      List<CarModel> cars = [];
      if (context.mounted) {
        cars = await ref.watch(tripControllerProvider.notifier).getCarDetails(
              context,
              double.parse(currentLocation?.latitude?.toString() ?? ''),
              double.parse(currentLocation?.longitude?.toString() ?? ''),
              double.parse(latitude?.toString() ?? ''),
              double.parse(
                longitude?.toString() ?? '',
              ),
            );
        setState(() {
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateCarIndex) =>
                  Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .5,
                child: Column(
                  children: [
                    const Text(
                      'Chọn loại xe',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Cuộn để xem thêm lựa chọn',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ref
                                  .watch(selectedCarIndexProvider.notifier)
                                  .state = index;
                              // print(ref
                              //     .watch(selectedCarIndexProvider.notifier)
                              //     .state);
                              setStateCarIndex(() {
                                //selectedCarIndex = index;
                              });
                            },
                            child: Card(
                              color:
                                  // selectedCarIndex == index
                                  //     ? Pallete.primaryColor
                                  //     : null,
                                  ref
                                              .read(selectedCarIndexProvider
                                                  .notifier)
                                              .state ==
                                          index
                                      ? Pallete.primaryColor
                                      : null,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Pallete.primaryColor,
                                  width: //selectedCarIndex == index ? 2.0 : 0.0,
                                      ref
                                                  .watch(
                                                      selectedCarIndexProvider
                                                          .notifier)
                                                  .state ==
                                              index
                                          ? 2.0
                                          : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(cars[index].image),
                                  ),
                                  Text(
                                    "Xe ${cars[index].capacity} chỗ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ref
                                                  .watch(
                                                      selectedCarIndexProvider
                                                          .notifier)
                                                  .state ==
                                              index
                                          ? Colors.white
                                          : Pallete.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "${oCcy.format(cars[index].totalPrice)} đồng",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ref
                                                  .watch(
                                                      selectedCarIndexProvider
                                                          .notifier)
                                                  .state ==
                                              index
                                          ? Colors.white
                                          : Pallete.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final data = await navigateToDependentList(context);
                        print(data);
                      },
                      child: const Text(
                        'Xác nhận',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Xác nhận',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeRepository = ref.read(homeRepositoryProvider);
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomSearchBar(onTap: () {
                        navigateToSearchTripRoute(context);
                      }),
                    ),
                  ],
                ),
                // SliverAppBar(
                //   expandedHeight: 200.0,
                //   floating: false,
                //   pinned: true,
                //   flexibleSpace: FlexibleSpaceBar(
                //     title: Text('Header'),
                //     background: Image.network(
                //       'https://example.com/your_image_url.jpg',
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
              ];
            },
            body: SafeArea(
              child: ListView(
                children: [
                  // Your other widgets
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
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
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  IconData(0xe050, fontFamily: 'MaterialIcons'),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Text(
                                'Tạo điểm đến',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // List of scrollable widgets
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: LocationCard(
                            onClick: (latitude, longitude) async {
                              _showBottomModal(
                                latitude,
                                longitude,
                                ref,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Other widgets
                  const SizedBox(
                    height: 20,
                  ),
                  HomeCenterContainer(
                    width: MediaQuery.of(context).size.width * .9,
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}

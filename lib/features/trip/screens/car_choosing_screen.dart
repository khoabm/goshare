import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/car_model.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:intl/intl.dart';

final selectedCarIndexProvider = StateProvider<int>((ref) => 0);
final selectedPaymentMethodProvider = StateProvider<String>((ref) => "Ví");

class CarChoosingScreen extends ConsumerStatefulWidget {
  final String startLongitude;
  final String startLatitude;
  final String endLongitude;
  final String endLatitude;

  const CarChoosingScreen({
    Key? key,
    required this.startLongitude,
    required this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
  }) : super(key: key);

  @override
  ConsumerState<CarChoosingScreen> createState() => _CarChoosingScreenState();
}

class _CarChoosingScreenState extends ConsumerState<CarChoosingScreen> {
  List<CarModel> cars = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    print(widget.startLatitude + 'heheheheeheheheheh');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cars = await ref.watch(tripControllerProvider.notifier).getCarDetails(
            context,
            double.parse(widget.startLatitude),
            double.parse(widget.startLongitude),
            double.parse(widget.endLatitude),
            double.parse(widget.endLongitude),
          );
      // Use setState to trigger a rebuild of the widget with the new data.
      setState(() {});
    });
  }

  void navigateToFindTripScreen(
    BuildContext context,
    String startLatitude,
    String startLongitude,
    String endLatitude,
    String endLongitude,
  ) {
    context.pushNamed(RouteConstants.findTrip, pathParameters: {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "vi_VN");

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          'Quay lại',
                          style: TextStyle(
                            fontSize: 16,
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
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      50,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Text(
                        "Chọn loại xe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      //height: MediaQuery.of(context).size.height * .7,
                      child: GridView.builder(
                        itemCount: cars.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 30,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              ref
                                  .watch(selectedCarIndexProvider.notifier)
                                  .state = index;

                              setState(() {});
                            },
                            child: Consumer(
                              builder: (context, ref, child) {
                                return Card(
                                  color: ref
                                              .watch(selectedCarIndexProvider
                                                  .notifier)
                                              .state ==
                                          index
                                      ? Pallete.primaryColor
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Pallete.primaryColor,
                                      width: ref
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Phương thức thanh toán',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Pallete.primaryColor,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String result) {
                            ref
                                .watch(selectedPaymentMethodProvider.notifier)
                                .state = result;
                            setState(() {});
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Ví',
                              child: Text('Ví'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Tiền Mặt',
                              child: Text('Tiền Mặt'),
                            ),
                          ],
                          child: Consumer(
                            builder: (context, ref, child) => RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: ref
                                        .watch(selectedPaymentMethodProvider
                                            .notifier)
                                        .state,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        onPressed: () {
                          // ref.invalidate(selectedPaymentMethodProvider);
                          navigateToFindTripScreen(
                            context,
                            widget.startLatitude,
                            widget.startLongitude,
                            widget.endLatitude,
                            widget.endLongitude,
                          );
                        },
                        child: const Text("Đặt xe"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

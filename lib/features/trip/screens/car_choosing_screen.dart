import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/dependent_location_model.dart';
import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:intl/intl.dart';

final selectedCarIndexProvider = StateProvider<int>((ref) => 0);
final selectedPaymentMethodProvider = StateProvider<int>((ref) => 0);

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
  DependentModel? passenger;
  DependentLocationModel? passengerLocation;
  String driverNote = '';
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

  void navigateToRouteConfirmScreen(
    BuildContext context,
    String startLatitude,
    String startLongitude,
    String endLatitude,
    String endLongitude,
    int paymentMethod,
    String bookerId,
    String carTypeId,
    String? driverNote,
  ) {
    context.replaceNamed(RouteConstants.routeConfirm, extra: {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'paymentMethod': paymentMethod.toString(),
      'bookerId': bookerId,
      'carTypeId': carTypeId,
      'driverNote': driverNote,
    });
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "vi_VN");
    //String passenger = 'Tôi';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  context.pop();
                },
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
                          childAspectRatio: 0.75,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                            .notifier,
                                                      )
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          PopupMenuButton<int>(
                            onSelected: (int result) {
                              ref
                                  .watch(selectedPaymentMethodProvider.notifier)
                                  .state = result;
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('Ví'),
                              ),
                              const PopupMenuItem<int>(
                                value: 2,
                                child: Text('Tiền Mặt'),
                              ),
                            ],
                            child: Consumer(
                              builder: (context, ref, child) => RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ref
                                                  .watch(
                                                      selectedPaymentMethodProvider
                                                          .notifier)
                                                  .state ==
                                              0
                                          ? 'Ví'
                                          : 'Tiền mặt',
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Lời nhắn',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Pallete.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 181,
                              height: 42,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: const Color.fromARGB(255, 178, 175, 175),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  driverNote,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final controller =
                                      TextEditingController(text: driverNote);
                                  return AlertDialog(
                                    title: const Text('Lời nhắn cho tài xế'),
                                    content: TextField(
                                      keyboardType: TextInputType.multiline,
                                      controller: controller,
                                      maxLines:
                                          null, // Allows for multiple lines
                                      onChanged: (value) {
                                        setState(() {
                                          driverNote = value;
                                        });
                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ref
                                .watch(userProvider.notifier)
                                .state
                                ?.role
                                .toLowerCase() ==
                            'dependent'
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Người đặt xe',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                ref.watch(userProvider.notifier).state?.role ==
                                        'dependent'
                                    ? const SizedBox.shrink()
                                    : GestureDetector(
                                        child: Container(
                                          width: 181,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: const Color.fromARGB(
                                                255, 237, 224, 224),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.person_2_outlined,
                                                    ),
                                                    Text(
                                                      passenger?.name ?? 'Tôi',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          final result =
                                              await context.pushNamed(
                                            RouteConstants.dependentList,
                                            extra: {
                                              'isGetLocation': true,
                                            },
                                          );
                                          if (result != null) {
                                            Map<String, dynamic> resultMap =
                                                result as Map<String, dynamic>;
                                            var dependentModel =
                                                resultMap['dependentModel'];
                                            var dependentLocationData =
                                                resultMap[
                                                    'dependentLocationData'];
                                            // Handle the returned data
                                            setState(() {
                                              passenger = (dependentModel
                                                  as DependentModel?);
                                              passengerLocation =
                                                  (dependentLocationData
                                                      as DependentLocationModel?);
                                            });
                                          }

                                          print(result);
                                        },
                                      ),
                              ],
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                            passenger?.id ??
                                ref.watch(userProvider.notifier).state?.id,
                          );
                          //ref.invalidate(selectedPaymentMethodProvider);
                          navigateToRouteConfirmScreen(
                            context,
                            widget.startLatitude,
                            widget.startLongitude,
                            widget.endLatitude,
                            widget.endLongitude,
                            ref
                                .watch(selectedPaymentMethodProvider.notifier)
                                .state,
                            passenger == null
                                ? ref.watch(userProvider.notifier).state!.id
                                : passenger!.id,
                            cars[ref
                                    .watch(selectedCarIndexProvider.notifier)
                                    .state]
                                .cartypeId,
                            driverNote,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/dependent_trip_provider.dart';

class TripInformationCardWidget extends ConsumerStatefulWidget {
  final int tripStatus;
  const TripInformationCardWidget({super.key, required this.tripStatus});
  @override
  ConsumerState<TripInformationCardWidget> createState() =>
      _TripInformationCardWidgetState();
}

List<String> announcements = [
  'Tài xế của bạn đang trên đường đến',
  'Bắt đầu di chuyển đến điểm chỉ định'
];

class _TripInformationCardWidgetState
    extends ConsumerState<TripInformationCardWidget> {
  // late final Driver? driver;
  TripModel? trip;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // trip?.driver = ref.watch(driverProvider.notifier).driverData;
    // print(trip?.driver?.toJson());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        trip = ref.watch(tripProvider.notifier).tripData;
        trip?.copyWith(driver: ref.watch(driverProvider.notifier).driverData);

        print("????????????????????????????????????????");
        print(trip.toString());
      });
    });
    // driver = ref.read(driverProvider.notifier).driverData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF05204A)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                announcements[widget.tripStatus],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              maxRadius: 100,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  ref.watch(driverProvider.notifier).driverData?.avatarUrl ??
                      trip?.driver?.avatarUrl ??
                      '',
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  width: 100 * 2,
                  height: 100 * 2,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.watch(driverProvider.notifier).driverData?.name ??
                        trip?.driver?.name ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Số điện thoại:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          convertBackPhoneNumber(
                            ref
                                    .watch(driverProvider.notifier)
                                    .driverData
                                    ?.phone ??
                                trip?.driver?.phone ??
                                '',
                          ),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Biển số xe:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          ref
                                  .watch(driverProvider.notifier)
                                  .driverData
                                  ?.car
                                  .licensePlate ??
                              trip?.driver?.car.licensePlate ??
                              '',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Loại xe:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              ref
                                      .watch(driverProvider.notifier)
                                      .driverData
                                      ?.car
                                      .make ??
                                  trip?.driver?.car.make ??
                                  '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              ' - ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              ref
                                      .watch(driverProvider.notifier)
                                      .driverData
                                      ?.car
                                      .model ??
                                  trip?.driver?.car.model ??
                                  '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

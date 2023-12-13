import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/dependent_trip_provider.dart';
import 'package:goshare/theme/pallet.dart';

class CountdownButton extends StatefulWidget {
  final VoidCallback onCountdownDone;
  final VoidCallback onPress;
  const CountdownButton({
    Key? key,
    required this.onCountdownDone,
    required this.onPress,
  }) : super(key: key);

  @override
  State createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<CountdownButton> {
  late Timer _timer;
  int _countdown = 120; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          // Countdown done
          _timer.cancel();
          widget.onCountdownDone();
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        height: 65,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: widget.onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                formatTime(_countdown),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripNotificationScreen extends ConsumerStatefulWidget {
  const TripNotificationScreen({super.key});

  @override
  ConsumerState<TripNotificationScreen> createState() =>
      _TripNotificationScreenState();
}

class _TripNotificationScreenState
    extends ConsumerState<TripNotificationScreen> {
  TripModel? trip;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //driver = ref.read(driverProvider.notifier).driverData;
    //print("Driver:" + driver!.toJson());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          trip = ref.watch(tripProvider.notifier).tripData;
          trip?.copyWith(driver: ref.watch(driverProvider.notifier).driverData);
        });
      }
    });

    //print("Trip:" + trip!.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                    trip?.driver?.avatarUrl ?? '',
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                trip?.driver?.name ?? '',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Xe ${trip?.cartype.capacity} chỗ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${trip?.distance.toString() ?? 1} km',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: Pallete.primaryColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            Text(
                              trip?.paymentMethod == 0 ? 'Ví' : 'Tiền mặt',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trip?.startLocation.address ?? 'Địa điểm đi',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 30,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 60, // Adjust the height as needed
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 8.0,
                        ),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Text(
                          trip?.endLocation.address ?? "Địa điểm đến",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Text(
                          trip?.note ?? 'Ghi chú',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CountdownButton(
                onCountdownDone: () {
                  context.pop();
                },
                onPress: () async {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

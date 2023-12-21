import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/trip_history/trip_history_controller.dart';
import 'package:goshare/features/trip_history/trip_picture_widget.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:intl/intl.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> {
  List<TripModel> trips = [];
  bool _isLoading = false;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    // Fetch data from API and update trips list
    fetchData();
  }

  void fetchData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      final result = await ref
          .read(TripHistoryControllerProvider.notifier)
          .tripHistory(context);
      if (mounted) {
        setState(() {
          if (mounted) {
            trips = result;
            _isLoading = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử chuyến'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Column(
                  children: [
                    trip.status != 3
                        ? const Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Chuyến đang chạy"),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    GestureDetector(
                      onTap: () {
                        print(trip.toJson());
                        _showTripDetails(context, trip);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: Text(
                              'Đến ${trip.endLocation.address}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                              'Đặt vào ${DateFormat('HH:mm - dd/MM/yyyy').format(trip.startTime)}'),
                        ),
                      ),
                    ),
                    trip.status != 3
                        ? const Divider(
                            color: Colors.black,
                          )
                        : const Divider(),
                  ],
                );
              },
            ),
    );
  }

  void _showTripDetails(BuildContext context, TripModel trip) {
    final oCcy = NumberFormat("#,##0", "vi_VN");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chi tiết chuyến đi', textAlign: TextAlign.center),
          content: IntrinsicHeight(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Set to MainAxisSize.min
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Tổng tiền: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text('${oCcy.format(trip.price)}đ',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Pallete.green)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Từ: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(
                                trip.startLocation.address,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Đến: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(
                                trip.endLocation.address,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Quãng đường: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${trip.distance.toString()}km',
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        trip.note != '' && trip.note != null
                            ? Row(
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Ghi chú: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      '${trip.note}',
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        const Text('Thông tin tài xế',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    trip.driver?.avatarUrl ?? '',
                                    scale: 0.7),
                                radius: 60,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${trip.driver?.name}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    convertBackPhoneNumber(trip.driver!.phone),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Xe ${trip.cartype.capacity} chỗ',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    'Biển số xe: ${trip.driver?.car?.licensePlate}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${trip.driver?.car?.make} ${trip.driver?.car?.model}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Thông tin người đặt',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(trip.booker.avatarUrl ?? ''),
                                radius: 60,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.booker.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    convertBackPhoneNumber(trip.booker.phone),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        (trip.type == 1 || trip.type == 2)
                            ? Column(
                                children: [
                                  const SizedBox(height: 20),
                                  const Text('Thông tin người đi',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(trip
                                                  .passenger.avatarUrl ??
                                              'https://firebasestorage.googleapis.com/v0/b/goshare-bc3c4.appspot.com/o/default-user-avatar.webp?alt=media&token=cd67cce4-611c-49c5-a819-956a33ce90ba'),
                                          radius: 60,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              trip.passengerName,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              convertBackPhoneNumber(
                                                  trip.passengerPhoneNumber ??
                                                      trip.passenger.phone),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        trip.type == 2
                            ? TripPicturesWidget(images: trip.tripImages)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}

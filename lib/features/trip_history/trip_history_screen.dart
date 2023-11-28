import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/features/trip_history/trip_history_controller.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/theme/pallet.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> {
  List<TripModel> trips = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from API and update trips list
    fetchData();
  }

  void fetchData() async {
    print('eiwrwereri');
    final result = await ref
        .read(TripHistoryControllerProvider.notifier)
        .tripHistory(context);

    // print(result);

    // List<Map<String, dynamic>> apiResponse = [
    //   {
    //     "id": "1",
    //     "startTime": "2023-11-15T08:00:00",
    //     "driver": {
    //       "name": "tiếng việt",
    //       "avatarUrl": 'https://imgflip.com/s/meme/Cute-Cat.jpg',
    //       "car": {"licensePlate": "ABC123"},
    //       "phone": "123456789",
    //     },
    //     "passenger": {
    //       "name": "tiếng việt Doe",
    //       "avatarUrl": 'https://imgflip.com/s/meme/Cute-Cat.jpg',
    //     },
    //     "booker": {
    //       "name": "tiếng việt Doe",
    //       "avatarUrl": 'https://imgflip.com/s/meme/Cute-Cat.jpg',
    //     },
    //     "startLocation": {"address": "tiếng việt Address"},
    //     "endLocation": {"address": "tiếng việt Address"},
    //     "distance": 10.0,
    //     "price": 50.0,
    //     "cartype": {"capacity": 4},
    //   },
    // ];

    setState(() {
      trips = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử chuyến'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white, // Set background color here
      body: trips.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showTripDetails(context, trip);
                      },
                      child: ListTile(
                        title: Text(
                          '${trip.passenger.name} đã đặt chuyến đi',
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        // ${trip['startTime'].toString().substring(11, 16)
                        subtitle: Text(
                            'Đặt vào ${trip.startTime.toString().substring(0, 10)} ${trip.startTime.toString().substring(11, 16)}'),
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            ),
    );
  }

  void _showTripDetails(BuildContext context, TripModel trip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chi tiết chuyến đi'),
          content: IntrinsicHeight(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set to MainAxisSize.min
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${trip.price}đ',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Pallete.green)),
                      SizedBox(height: 20),
                      Text(
                        'Chuyến đi đã bắt đầu từ ${trip.startLocation.address} đến ${trip.endLocation.address}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      const Text('Thông tin tài xế',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(trip.driver?.avatarUrl ?? ''),
                            radius: 30,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${trip.driver?.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${trip.driver?.phone}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Xe ${trip.cartype.capacity} chỗ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Biển số xe ${trip.driver?.car.licensePlate}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      const Text('Thông tin người đặt',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(trip.driver?.avatarUrl ?? ''),
                            radius: 30,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${trip.driver?.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${trip.driver?.phone}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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

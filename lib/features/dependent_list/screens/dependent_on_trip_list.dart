import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';

class DependentListTrip extends ConsumerStatefulWidget {
  const DependentListTrip({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DependentListTripState();
}

class _DependentListTripState extends ConsumerState<DependentListTrip> {
  void navigateToDriverPickupScreen(
    String driverName,
    String driverCarType,
    String driverPlate,
    String driverPhone,
    String driverAvatar,
    String driverId,
    String endLatitude,
    String endLongitude,
  ) {
    context.pushNamed(RouteConstants.driverPickUp, extra: {
      'driverName': driverName,
      'driverCarType': driverCarType,
      'driverPlate': driverPlate,
      'driverPhone': driverPhone,
      'driverAvatar': driverAvatar,
      'driverId': driverId,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
    });
  }

  void navigateToGuardianObserverScreen(
    TripModel trip,
  ) {
    context.pushNamed(RouteConstants.guardianObserveDependentTrip, extra: {
      'trip': trip,
    });
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(currentDependentOnTripProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyến xe của người thân'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return GestureDetector(
            onTap: () async {
              // Handle onTap here
              print('Tapped on Trip ID: ${trip.id}');
              final result =
                  await ref.watch(tripControllerProvider.notifier).getTripInfo(
                        context,
                        trip.id,
                      );
              if (result != null) {
                if (result.status == 1) {
                  navigateToDriverPickupScreen(
                    result.driver?.name ?? 'Không rõ',
                    result.driver?.car.make ?? '',
                    result.driver?.car.licensePlate ?? '',
                    result.driver?.phone ?? '',
                    result.driver?.avatarUrl ?? '',
                    result.driver?.id ?? '',
                    result.endLocation.latitude.toString(),
                    result.endLocation.latitude.toString(),
                  );
                }
                if (result.status == 2) {
                  navigateToGuardianObserverScreen(result);
                }
              }
            },
            child: Card(
              child: ListTile(
                title: Text(
                  'Chuyến xe của ${trip.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Bấm vào để xem chi tiết',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}

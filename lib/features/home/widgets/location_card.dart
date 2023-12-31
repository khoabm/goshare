import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/models/location_model.dart';
import 'package:goshare/theme/pallet.dart';

class LocationCard extends ConsumerWidget {
  final LocationModel? locationModel;
  final Function(double latitude, double longitude) onClick;
  const LocationCard({
    super.key,
    required this.onClick,
    this.locationModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 24,
      ),
      width: MediaQuery.of(context).size.width * .9,
      // width: 336,
      // height: 118,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          11,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationModel?.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // SizedBox(height: 8),
                // Text(
                //   'Cách đây 5km',
                //   style: TextStyle(
                //     fontStyle: FontStyle.italic,
                //     fontWeight: FontWeight.w400,
                //     fontSize: 13,
                //   ),
                // ),
                const SizedBox(height: 8),
                Text(
                  locationModel?.address ?? '',
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Pallete.primaryColor,
              ),
              onPressed: () async {
                print(locationModel);
                await onClick(
                  locationModel?.latitude ?? 0.0,
                  locationModel?.longitude ?? 0.0,
                );
              },
              child: const Text(
                'Đặt xe',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

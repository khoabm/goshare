import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationCard extends ConsumerWidget {
  const LocationCard({super.key});

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
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhà ngoại',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cách đây 5km',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '75C Cách mạng tháng 8 phường 1, Tân An, Long An',
                  maxLines: 2,
                  style: TextStyle(
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
              ),
              onPressed: () {},
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

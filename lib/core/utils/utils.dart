import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

void showLoginTimeOut({
  required BuildContext context,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Phiên đăng nhập hết hạn'),
        content: const Text('Vui lòng đăng nhập lại.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              context.pop();
              context.go(RouteConstants.loginUrl);
            },
          ),
        ],
      );
    },
  );
}

void showAlreadyInTripError({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Có lỗi xảy ra'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              context.pop();
              context.go(RouteConstants.dashBoardUrl);
            },
          ),
        ],
      );
    },
  );
}

String convertPhoneNumber(String phoneNumber) {
  // Check if the phone number starts with '0'
  if (phoneNumber.startsWith('0')) {
    // Remove the leading '0' and add '84' at the beginning
    return '+84${phoneNumber.substring(1)}';
  } else {
    // If the phone number doesn't start with '0', return as is
    return phoneNumber;
  }
}

void showNavigateDashBoardDialog(TripModel trip, BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Tài xế ${trip.driver?.name} đã hoàn thành chuyến đi',
          ),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Người thân ${trip.passenger.name} đã hoàn thành chuyến đi'),
                  Text('Tổng số tiền được thanh toán là: ${trip.price}đ'),
                  const Text('Cảm ơn bạn đã sử dụng dịch vụ'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(RouteConstants.dashBoard);
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
        ],
      );
    },
  );
}

void showDialogInfo(TripModel? trip, BuildContext context, WidgetRef ref) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            '${trip?.booker.name} đang tìm xe cho bạn',
          ),
        ),
        content: const SizedBox.shrink(),
        actions: [
          ElevatedButton(
            onPressed: () {
              abcContext.pop();
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool check =
                  await ref.watch(tripControllerProvider.notifier).cancelTrip(
                        context,
                        trip?.id ?? '',
                      );
              if (context.mounted) {
                if (check == true) {
                  ref.watch(stageProvider.notifier).setStage(Stage.stage0);
                }
                abcContext.pop();
              }
            },
            child: const Text(
              'Hủy',
            ),
          ),
        ],
      );
    },
  );
}

void showDialogInfoPickUp(TripModel trip, BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Tài xế ${trip.driver?.name} đã đến',
          ),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Bạn đã đặt xe: ${trip.driver?.car.make} ${trip.driver?.car.model}'),
                  Text('Biển số xe: ${trip.driver?.car.licensePlate}'),
                  Text('Số điện thoại tài xế: ${trip.driver?.phone}'),
                  const Text('Vui lòng tìm tài xế của bạn gần đó'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              //context.pop();
              abcContext.goNamed(
                RouteConstants.onTrip,
                extra: {
                  'trip': trip,
                },
              );
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
        ],
      );
    },
  );
}

// void showDialogInfoPickUp(TripModel trip, BuildContext context) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext abcContext) {
//       return AlertDialog(
//         title: Center(
//           child: Text(
//             'Tài xế ${trip.driver?.name} đã đến',
//           ),
//         ),
//         content: const SizedBox.shrink(),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               abcContext.goNamed(
//                 RouteConstants.onTrip,
//                 extra: {
//                   'trip': trip,
//                 },
//               );
//             },
//             child: const Text(
//               'Xác nhận',
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

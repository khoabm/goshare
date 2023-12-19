import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/signup/controller/sign_up_controller.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';
import 'package:goshare/theme/pallet.dart';
import 'package:image_picker/image_picker.dart';

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
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Phiên đăng nhập hết hạn'),
        content: const Text('Vui lòng đăng nhập lại.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              //context.go(RouteConstants.loginUrl);
              GoRouter.of(context).goNamed(RouteConstants.login);
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
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Có lỗi xảy ra'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              GoRouter.of(context).goNamed(RouteConstants.dashBoard);
            },
          ),
        ],
      );
    },
  );
}

void showFindTripErrorDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Có lỗi xảy ra'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              GoRouter.of(context).goNamed(RouteConstants.dashBoard);
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

String convertBackPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith('+84')) {
    return '0${phoneNumber.substring(3)}';
  }
  return phoneNumber;
}

Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

void showNavigateDashBoardDialog(TripModel trip, BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext dialogContext) {
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
              Navigator.of(dialogContext).pop();
              GoRouter.of(context).goNamed(RouteConstants.dashBoard);
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
              Navigator.of(abcContext).pop();
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

void showCancelDialogInfo(
    TripModel? trip, BuildContext context, WidgetRef ref) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            '${trip?.booker.name} đã hủy tìm xe cho bạn',
          ),
        ),
        content: const SizedBox.shrink(),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
              ref.watch(stageProvider.notifier).setStage(Stage.stage0);
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     ref.watch(stageProvider.notifier).setStage(Stage.stage0);

          //     abcContext.pop();
          //   },
          //   child: const Text(
          //     'Hủy',
          //   ),
          // ),
        ],
      );
    },
  );
}

void showAdminCancelDialogInfo(
    TripModel? trip, BuildContext context, WidgetRef ref) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Chuyến đi đã bị hủy',
          ),
        ),
        content: const SizedBox.shrink(),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
              ref
                  .watch(currentOnTripIdProvider.notifier)
                  .setCurrentOnTripId(null);
              ref.watch(stageProvider.notifier).setStage(Stage.stage0);
              GoRouter.of(context).goNamed(RouteConstants.dashBoard);
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     ref.watch(stageProvider.notifier).setStage(Stage.stage0);

          //     abcContext.pop();
          //   },
          //   child: const Text(
          //     'Hủy',
          //   ),
          // ),
        ],
      );
    },
  );
}

void showDialogTripCancel(
    TripModel? trip, BuildContext context, WidgetRef ref) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Người thân ${trip?.booker.name} đã hủy tìm xe',
          ),
        ),
        content: const SizedBox.shrink(),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (context.mounted) {
          //       ref.watch(stageProvider.notifier).setStage(Stage.stage0);
          //       Navigator.of(abcContext).pop();
          //     }
          //   },
          //   child: const Text(
          //     'Hủy',
          //   ),
          // ),
        ],
      );
    },
  );
}

void showWalletInsufficient(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Ví của bạn không đủ',
          ),
        ),
        content: const Center(
          child: Text("Mời bạn nạp lại ví hoặc thanh toán bằng tiền mặt"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showFeedbackSuccess(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Cảm ơn bạn đã góp ý',
          ),
        ),
        content: const Center(
          child: Text("Đánh giá của bạn đã được chúng tôi ghi nhận"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
              GoRouter.of(context).goNamed(RouteConstants.dashBoard);
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

void showDialogInfoPickUp(TripModel trip, BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Tài xế ${trip.driver?.name} đã đến',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(
                      'Bạn đã đặt xe: ${trip.driver?.car?.make} ${trip.driver?.car?.model}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number),
                    title: Text(
                      'Biển số xe: ${trip.driver?.car?.licensePlate}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      'Số điện thoại tài xế:${trip.driver?.phone}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Vui lòng tìm tài xế của bạn gần đó'),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              //navigateToOnTripScreen(trip);
            },
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                  color: Pallete.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

void showDialogInfoPickUpV2(TripModel trip, BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'Tài xế ${trip.driver?.name} đã đến',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(
                      'Bạn đã đặt xe: ${trip.driver?.car?.make} ${trip.driver?.car?.model}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number),
                    title: Text(
                      'Biển số xe: ${trip.driver?.car?.licensePlate}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      'Số điện thoại tài xế:${trip.driver?.phone}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Vui lòng tìm tài xế của bạn gần đó'),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                  color: Pallete.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

// void showDialogInfoPickUp(TripModel trip, BuildContext context) {
//   showDialog(
//     barrierDismissible: true,
//     context: context,
//     builder: (BuildContext abcContext) {
//       return AlertDialog(
//         title: Center(
//           child: Text(
//             'Tài xế ${trip.driver?.name} đã đến',
//           ),
//         ),
//         content: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                       'Bạn đã đặt xe: ${trip.driver?.car.make} ${trip.driver?.car.model}'),
//                   Text('Biển số xe: ${trip.driver?.car.licensePlate}'),
//                   Text('Số điện thoại tài xế: ${trip.driver?.phone}'),
//                   const Text('Vui lòng tìm tài xế của bạn gần đó'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               //context.pop();
//               Navigator.of(abcContext).pop();
//               context.pushNamed(
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

void showWrongPasswordDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Lỗi đăng nhập',
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text('Số điện thoại hoặc mật khẩu không chính xác'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showBannedDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Lỗi đăng nhập',
              ),
            ),
          ],
        ),
        content: Center(
          child: Text(message),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showNotVerifiedDialog(BuildContext context, WidgetRef ref, String phone) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Lỗi đăng nhập',
          ),
        ),
        content: const Center(
          child: Text(
              'Tài khoản chưa xác thực. Chọn "Xác nhận" để tiếp tục xác thực'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .watch(signUpControllerProvider.notifier)
                  .reSendOtpVerification(
                    phone,
                    context,
                  );
              if (context.mounted) {
                Navigator.of(abcContext).pop();
                if (result == true) {
                  context.goNamed(
                    RouteConstants.otp,
                  );
                }
              }
            },
            child: const Text(
              'Xác nhận',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showFeedBackError(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Lỗi phản hồi',
              ),
            ),
          ],
        ),
        content: Center(
          child: Text(message),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Lỗi cập nhật thông tin',
              ),
            ),
          ],
        ),
        content: Center(
          child: Text(message),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showAlreadyInTripErrorDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Lỗi cập tạo chuyến',
              ),
            ),
          ],
        ),
        content: Center(
          child: Text(message),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

void showUpdateProfileSuccessDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext abcContext) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Cập nhật thành công',
              ),
            ),
          ],
        ),
        content: const SizedBox.shrink(),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(abcContext).pop();
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

// void showWrongPhoneNumberDialog(BuildContext context) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext abcContext) {
//       return AlertDialog(
//         title: const Center(
//           child: Text(
//             'Lỗi đăng nhập',
//           ),
//         ),
//         content: const Center(
//           child: Text('Số điện thoại không chính xác'),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(abcContext).pop();
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

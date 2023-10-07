import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';

class ConnectToDriver extends ConsumerStatefulWidget {
  const ConnectToDriver({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectToDriverState();
}

class _ConnectToDriverState extends ConsumerState<ConnectToDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: HomeCenterContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Chờ chút, chúng tôi đang tìm tài xế cho bạn',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Loader(),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Vui lòng không thoát khỏi trang khi đang tìm tài xế',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                width: MediaQuery.of(context).size.width * .6,
                child: AppButton(
                  buttonText: 'Hủy',
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

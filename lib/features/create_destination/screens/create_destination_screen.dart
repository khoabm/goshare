import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/features/home/screen/home_screen.dart';

class CreateDestinationScreen extends ConsumerStatefulWidget {
  const CreateDestinationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateDestinationScreenState();
}

class _CreateDestinationScreenState
    extends ConsumerState<CreateDestinationScreen> {
  final locationNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeCenterContainer(
        child: Column(
          children: [
            const Text(
              'Tạo điểm đến mới',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Địa chỉ ',
                ),
                CustomSearchBar(
                  onTap: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Tên gợi nhớ ',
                ),
                AppTextField(
                  controller: locationNameTextController,
                  hintText: 'Đặt tên cho địa điểm,',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Tên gợi nhớ ',
                ),
                Container(),
              ],
            ),
            AppButton(
              buttonText: 'Tạo',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

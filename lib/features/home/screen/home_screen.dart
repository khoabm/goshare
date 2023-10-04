import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/large_button.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/theme/pallet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Home Screen')),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  width: MediaQuery.of(context)
                      .size
                      .width, // This will take the full width of your screen
                  height: MediaQuery.of(context).size.height * .25,
                  child: SvgPicture.asset(
                    Constants.carBanner,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .05,
                  left: MediaQuery.of(context).size.width * .1,
                  child: Text(
                    'Chào Khải, ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Pallete.primaryColor,
                      backgroundColor: Colors.black.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn muốn đi đến đâu ?',
                    style: TextStyle(
                      color: Pallete.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    width: 200, // adjust width as needed
                    height: 60, // adjust height as needed
                    child: LargeButton(
                      buttonText: 'Nhà',
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    width: 200, // adjust width as needed
                    height: 60,
                    child: LargeButton(
                      buttonText: 'Nơi làm việc',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

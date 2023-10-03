import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/large_button.dart';
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
                    'assets/images/car_banner.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 35.0,
                  left: 35.0,
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
                      color: Color.fromRGBO(5, 32, 74, 1),
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

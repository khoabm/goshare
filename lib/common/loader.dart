import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshare/theme/pallet.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}

class LoaderPrimary extends StatelessWidget {
  const LoaderPrimary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Pallete.primaryColor,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG image
            SvgPicture.asset(
              'assets/images/car_banner.svg', // Replace with your SVG file path
              height: 150, // Adjust the height
              width: 150, // Adjust the width
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Goshare',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Customize the text color
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Chuyến đi an toàn cho người thân của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Customize the text color
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

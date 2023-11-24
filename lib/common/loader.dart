import 'package:flutter/material.dart';
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

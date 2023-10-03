import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Home Screen')),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context)
              .size
              .width, // This will take the full width of your screen
          height: MediaQuery.of(context).size.height * .2,
          child: SvgPicture.asset(
            'assets/images/car_banner.svg',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

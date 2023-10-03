import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/router.dart';
import 'package:goshare/theme/pallet.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // routerDelegate: AppRouter().router.routerDelegate,
      //routeInformationParser: AppRouter().router.routeInformationParser,
      routerConfig: AppRouter().router,
      theme: ThemeData(
        scaffoldBackgroundColor: Pallete.primaryColor,
      ),
    );
  }
}

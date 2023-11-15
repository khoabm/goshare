import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/firebase_options.dart';
import 'package:goshare/router.dart';
import 'package:goshare/theme/pallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Pallete.primaryColor,
            ),
        primaryColor: Pallete.primaryColor,
        scaffoldBackgroundColor: Pallete.primaryColor,
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: Pallete.primaryColor,
              bodyColor: Pallete.primaryColor,
            ),
      ),
    );
  }
}

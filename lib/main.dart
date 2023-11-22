import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/login/controller/log_in_controller.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref
          .watch(LoginControllerProvider.notifier)
          .getUserData(context, ref), // Replace with your actual token
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader(); // Show a loading spinner while waiting
        } else {
          final initialLocation =
              snapshot.data != null && snapshot.data!.isNotEmpty
                  ? RouteConstants.dashBoardUrl
                  : RouteConstants
                      .loginUrl; // Replace 'login' with your actual login route

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter().createRouter(initialLocation),
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
      },
    );
    // MaterialApp.router(
    //   debugShowCheckedModeBanner: false,
    //   // routerDelegate: AppRouter().router.routerDelegate,
    //   //routeInformationParser: AppRouter().router.routeInformationParser,
    //   routerConfig: AppRouter().router,
    //   theme: ThemeData(
    //     colorScheme: ThemeData().colorScheme.copyWith(
    //           primary: Pallete.primaryColor,
    //         ),
    //     primaryColor: Pallete.primaryColor,
    //     scaffoldBackgroundColor: Pallete.primaryColor,
    //     fontFamily: 'Raleway',
    //     textTheme: Theme.of(context).textTheme.apply(
    //           displayColor: Pallete.primaryColor,
    //           bodyColor: Pallete.primaryColor,
    //         ),
    //   ),
    // );
  }
}

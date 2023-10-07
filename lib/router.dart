import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/page_navigation.dart';
import 'package:goshare/details_screen.dart';
import 'package:goshare/features/connect_to_driver/screen/connect_to_driver_screen.dart';
import 'package:goshare/features/dashboard/screen/dashboard.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/home_trip/screen/home_trip_screen.dart';
import 'package:goshare/features/signup/screen/sign_up_screen.dart';

class AppRouter {
  /// The route configuration.
  final GoRouter router = GoRouter(
    initialLocation: RouteConstants.dashBoardUrl,
    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.dashBoard,
        path: RouteConstants.dashBoardUrl,
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
        ) {
          return SlideRightTransition(
            child: const DashBoard(),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.home,
        path: RouteConstants.homeUrl,
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
        ) {
          return SlideRightTransition(
            child: const HomeScreen(),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: '/details',
        pageBuilder: (context, state) => SlideBottomTransition(
          child: const DetailsScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: RouteConstants.signupUrl,
        pageBuilder: (context, state) => SlideBottomTransition(
          child: const SignUpScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: RouteConstants.homeTripUrl,
        pageBuilder: (context, state) => SlideBottomTransition(
          child: const HomeTripScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: RouteConstants.connectToDriverUrl,
        pageBuilder: (context, state) => SlideBottomTransition(
          child: const ConnectToDriver(),
          key: state.pageKey,
        ),
      ),
    ],
  );
}

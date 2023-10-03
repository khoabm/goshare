import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/page_navigation.dart';
import 'package:goshare/details_screen.dart';
import 'package:goshare/features/home/screen/home_screen.dart';

class AppRouter {
  /// The route configuration.
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.home,
        path: '/',
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
      )
    ],
  );
}

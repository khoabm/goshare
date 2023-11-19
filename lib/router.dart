import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/page_navigation.dart';
import 'package:goshare/details_screen.dart';
import 'package:goshare/features/connect_to_driver/screen/connect_to_driver_screen.dart';
import 'package:goshare/features/dashboard/screen/dashboard.dart';
import 'package:goshare/features/dependent_list/screens/dependent_list_screen.dart';
import 'package:goshare/features/home/screen/home_screen.dart';
import 'package:goshare/features/trip/screens/car_choosing_screen.dart';
import 'package:goshare/features/trip/screens/find_trip_screen.dart';
import 'package:goshare/features/trip/screens/search_trip_route_screen.dart';
import 'package:goshare/features/signup/screen/otp_screen.dart';
import 'package:goshare/features/signup/screen/set_passcode_screen.dart';
import 'package:goshare/features/signup/screen/sign_up_screen.dart';
import 'package:goshare/location_display_demo.dart';

class AppRouter {
  /// The route configuration.
  final GoRouter router = GoRouter(
    initialLocation: RouteConstants.dashBoardUrl, //'/find-trip',
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
      // GoRoute(
      //   path: RouteConstants.homeTripUrl,
      //   pageBuilder: (context, state) => SlideBottomTransition(
      //     child: const FindTripScreen(),
      //     key: state.pageKey,
      //   ),
      // ),
      GoRoute(
        name: 'connect-to-driver',
        path: RouteConstants.connectToDriverUrl,
        pageBuilder: (context, state) => SlideBottomTransition(
          child: const ConnectToDriver(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        name: RouteConstants.otp,
        path: RouteConstants.otpUrl,
        pageBuilder: (context, state) {
          // Extract the parameters from the route
          final Map<String, dynamic> params = state.pathParameters;
          final String? phone = params['phone'] as String?;

          return SlideBottomTransition(
            child: OtpScreen(
              phone: phone ?? '',
            ), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.passcode,
        path: RouteConstants.passcodeUrl,
        pageBuilder: (context, state) {
          // Extract the parameters from the route
          final Map<String, dynamic> params = state.pathParameters;
          final String? phone = params['phone'] as String?;
          final String? setToken = params['setToken'] as String?;

          return SlideBottomTransition(
            child: SetPassCodeScreen(
              phone: phone ?? '',
              setToken: setToken ?? '',
            ), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: 'location-display',
        path: '/location-display/:refId',
        pageBuilder: (context, state) {
          // Extract the parameters from the route
          final Map<String, dynamic> params = state.pathParameters;
          // final String? longitude = params['longitude'] as String?;
          // final String? latitude = params['latitude'] as String?;
          final String? refId = params['refId'] as String?;

          return SlideBottomTransition(
            child: LocationDisplayDemo(
              refId: refId ?? '',
            ), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.carChoosing,
        path: RouteConstants.carChoosingUrl,
        pageBuilder: (context, state) {
          // Extract the parameters from the route
          final Map<String, dynamic> params = state.pathParameters;
          // final String? longitude = params['longitude'] as String?;
          // final String? latitude = params['latitude'] as String?;
          final String? startLatitude = params['startLatitude'] as String?;
          final String? startLongitude = params['startLongitude'] as String?;
          final String? endLatitude = params['endLatitude'] as String?;
          final String? endLongitude = params['endLongitude'] as String?;

          return SlideBottomTransition(
            child: CarChoosingScreen(
              //startLatitude: startLatitude ?? '10.8756434',
              startLatitude: '10.8756434',
              //startLongitude: startLongitude ?? '106.8006742',
              startLongitude: '106.8006742',
              //endLatitude: endLatitude ?? '10.682559',
              endLatitude: '10.682559',
              //endLongitude: endLongitude ?? '106.748967',
              endLongitude: '106.748967',
            ), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.searchTripRoute,
        path: RouteConstants.searchTripRouteUrl,
        pageBuilder: (context, state) {
          return SlideBottomTransition(
            child:
                const SearchTripRouteScreen(), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.findTrip,
        path: RouteConstants.findTripUrl,
        pageBuilder: (context, state) {
          // Extract the parameters from the route
          final Map<String, dynamic> params = state.pathParameters;
          // final String? longitude = params['longitude'] as String?;
          // final String? latitude = params['latitude'] as String?;
          final String? startLatitude = params['startLatitude'] as String?;
          final String? startLongitude = params['startLongitude'] as String?;
          final String? endLatitude = params['endLatitude'] as String?;
          final String? endLongitude = params['endLongitude'] as String?;
          return SlideBottomTransition(
            child: FindTripScreen2(
              startLatitude: startLatitude ?? '',
              startLongitude: startLongitude ?? '',
              endLatitude: endLatitude ?? '',
              endLongitude: endLongitude ?? '',
            ), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: 'dependent-list',
        path: '/dependent-list',
        pageBuilder: (context, state) {
          return SlideRightTransition(
            child:
                const DependentList(), // Pass the phone parameter to OtpScreen
            key: state.pageKey,
          );
        },
      ),
    ],
  );
}

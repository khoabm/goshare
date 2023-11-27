import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/page_navigation.dart';
import 'package:goshare/details_screen.dart';
import 'package:goshare/features/connect_to_driver/screen/connect_to_driver_screen.dart';
import 'package:goshare/features/create_destination/screens/create_destination_screen.dart';
import 'package:goshare/features/dashboard/screen/dashboard.dart';
import 'package:goshare/features/dependent_list/screens/dependent_list_screen.dart';
import 'package:goshare/features/dependent_list/screens/dependent_on_trip_list.dart';
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_otp_screen.dart';
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_screen.dart';
import 'package:goshare/features/feedback/feedback.dart';
import 'package:goshare/features/home/screen/home_screen.dart';

// import 'package:goshare/features/home_trip/screen/find_trip_screen.dart';
// import 'package:goshare/features/search_trip_route/screens/car_choosing_screen.dart';
// import 'package:goshare/features/search_trip_route/screens/find_trip_screen.dart';
// import 'package:goshare/features/search_trip_route/screens/search_trip_route_screen.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/menu_user/edit-profile/edit-profile-screen.dart';
import 'package:goshare/features/menu_user/money-topup/money-topup-screen.dart';

import 'package:goshare/features/trip/screens/car_choosing_screen.dart';
import 'package:goshare/features/trip/screens/chat_screen.dart';
import 'package:goshare/features/trip/screens/driver_pick_up_screen.dart';
import 'package:goshare/features/trip/screens/find_trip_screen.dart';
import 'package:goshare/features/trip/screens/guardian_orbserve_dependent_trip_screen.dart';
import 'package:goshare/features/trip/screens/on_trip_screen.dart';
import 'package:goshare/features/trip/screens/rate_driver_screen.dart';
import 'package:goshare/features/trip/screens/route_confirm_screen.dart';
import 'package:goshare/features/trip/screens/search_trip_route_screen.dart';

import 'package:goshare/features/signup/screen/otp_screen.dart';
import 'package:goshare/features/signup/screen/set_passcode_screen.dart';
import 'package:goshare/features/signup/screen/sign_up_screen.dart';
import 'package:goshare/models/trip_model.dart';

class AppRouter {
  /// The route configuration.

  GoRouter createRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation, //'/find-trip',

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
          name: RouteConstants.login,
          path: RouteConstants.loginUrl,
          pageBuilder: (context, state) => SlideBottomTransition(
            child: const LogInScreen(),
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: RouteConstants.editProfileUrl,
          pageBuilder: (context, state) => SlideRightTransition(
            child: const EditProfilePage(),
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: RouteConstants.moneyTopupUrl,
          pageBuilder: (context, state) => SlideLeftTransition(
            child: const MoneyTopupPage(),
            key: state.pageKey,
          ),
        ),
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
            final String? isFor = params['isFor'] as String?;

            return SlideBottomTransition(
              child: OtpScreen(
                phone: phone ?? '',
                isFor: isFor ?? RouteConstants.signup,
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
            final String? isFor = params['isFor'] as String?;

            return SlideBottomTransition(
              child: SetPassCodeScreen(
                phone: phone ?? '',
                setToken: setToken ?? '',
                isFor: isFor ?? RouteConstants.signup,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        // GoRoute(
        //   name: 'location-display',
        //   path: '/location-display/:refId',
        //   pageBuilder: (context, state) {
        //     // Extract the parameters from the route
        //     final Map<String, dynamic> params = state.pathParameters;
        //     // final String? longitude = params['longitude'] as String?;
        //     // final String? latitude = params['latitude'] as String?;
        //     final String? refId = params['refId'] as String?;

        //     return SlideBottomTransition(
        //       child: LocationDisplayDemo(
        //         refId: refId ?? '',
        //       ), // Pass the phone parameter to OtpScreen
        //       key: state.pageKey,
        //     );
        //   },
        // ),
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
                startLatitude: startLatitude ?? '0',
                //startLongitude: startLongitude ?? '106.8006742',
                startLongitude: startLongitude ?? '0',
                //endLatitude: endLatitude ?? '10.682559',
                endLatitude: endLatitude ?? '0',
                //endLongitude: endLongitude ?? '106.748967',
                endLongitude: endLongitude ?? '0',
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
            final extras = state.extra as Map<String, dynamic>;
            // final String? longitude = params['longitude'] as String?;
            // final String? latitude = params['latitude'] as String?;
            final String? startLatitude = extras['startLatitude'] as String?;
            final String? startLongitude = extras['startLongitude'] as String?;
            final String? endLatitude = extras['endLatitude'] as String?;
            final String? endLongitude = extras['endLongitude'] as String?;
            final String? paymentMethod = extras['paymentMethod'] as String?;
            final String? bookerId = extras['bookerId'] as String?;
            final String? carTypeId = extras['carTypeId'] as String?;
            final String? driverNote = extras['driverNote'] as String?;
            final bool? isFindingTrip = extras['isFindingTrip'] as bool?;
            //final String? driverNote = params['driverNote'] as String?;
            return SlideBottomTransition(
              child: FindTripScreen2(
                driverNote: driverNote,
                startLatitude: startLatitude ?? '',
                startLongitude: startLongitude ?? '',
                endLatitude: endLatitude ?? '',
                endLongitude: endLongitude ?? '',
                bookerId: bookerId ?? '',
                paymentMethod: paymentMethod ?? '0',
                carTypeId: carTypeId ?? '',
                isFindingTrip: isFindingTrip,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.dependentList,
          path: RouteConstants.dependentListUrl,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final bool isGetLocation = extras['isGetLocation'] as bool;
            return SlideRightTransition(
              child: DependentList(
                isGetLocation: isGetLocation,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.dependentAddUrl,
          path: RouteConstants.dependentAddUrl,
          pageBuilder: (context, state) {
            return SlideRightTransition(
              child: DependentAddScreen(),
              key: state.pageKey,
            );
          },
        ),
        // GoRoute(
        //   name: RouteConstants.dependentAddOtp,
        //   path: RouteConstants.dependentAddOtpUrl,
        //   pageBuilder: (context, state) {
        //     return SlideRightTransition(
        //       child: DependentAddOtpScreen(),
        //       key: state.pageKey,
        //     );
        //   },
        // ),
        GoRoute(
          path: RouteConstants.feedback,
          pageBuilder: (context, state) => SlideLeftTransition(
            child: const FeedbackScreen(),
            key: state.pageKey,
          ),
        ),
        GoRoute(
          name: RouteConstants.driverPickUp,
          path: RouteConstants.driverPickUpUrl,
          pageBuilder: (context, state) {
            //final Map<String, dynamic> params = state.pathParameters;
            final extras = state.extra as Map<String, dynamic>;
            final String driverName = extras['driverName'] as String;
            final String driverPhone = extras['driverPhone'] as String;
            final String driverAvatar = extras['driverAvatar'] as String;
            final String driverPlate = extras['driverPlate'] as String;
            final String driverCarType = extras['driverCarType'] as String;
            final String driverId = extras['driverId'] as String;
            final String endLatitude = extras['endLatitude'] as String;
            final String endLongitude = extras['endLongitude'] as String;
            return SlideRightTransition(
              child: DriverPickUpScreen(
                driverId: driverId,
                driverName: driverName,
                driverPhone: driverPhone,
                driverAvatar: driverAvatar,
                driverPlate: driverPlate,
                driverCarType: driverCarType,
                endLatitude: endLatitude,
                endLongitude: endLongitude,
              ),
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.onTrip,
          path: RouteConstants.onTripUrl,
          pageBuilder: (context, state) {
            //final Map<String, dynamic> params = state.pathParameters;
            final extra = state.extra as Map<String, TripModel>;
            final trip = extra['trip'] as TripModel;
            // final String driverName = extras['driverName'] as String;
            // final String driverPhone = extras['driverPhone'] as String;
            // final String driverAvatar = extras['driverAvatar'] as String;
            // final String driverPlate = extras['driverPlate'] as String;
            // final String driverCarType = extras['driverCarType'] as String;
            // final String driverId = extras['driverId'] as String;
            // final String endLatitude = extras['endLatitude'] as String;
            // final String endLongitude = extras['endLongitude'] as String;
            return SlideRightTransition(
              child: OnTripScreen(
                trip: trip,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.chat,
          path: RouteConstants.chatUrl,
          pageBuilder: (context, state) {
            final Map<String, dynamic> params = state.pathParameters;
            final String receiver = params['receiver'] as String;
            final String driverAvatar = params['driverAvatar'] as String;
            return SlideRightTransition(
              child: ChatScreen(
                receiver: receiver,
                driverAvatar: driverAvatar,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.routeConfirm,
          path: RouteConstants.routeConfirmUrl,
          pageBuilder: (context, state) {
            //final Map<String, dynamic> params = state.pathParameters;
            final extras = state.extra as Map<String, dynamic>;
            // final String? longitude = params['longitude'] as String?;
            // final String? latitude = params['latitude'] as String?;
            final String? startLatitude = extras['startLatitude'] as String?;
            final String? startLongitude = extras['startLongitude'] as String?;
            final String? endLatitude = extras['endLatitude'] as String?;
            final String? endLongitude = extras['endLongitude'] as String?;
            final String? paymentMethod = extras['paymentMethod'] as String?;
            final String? bookerId = extras['bookerId'] as String?;
            final String? carTypeId = extras['carTypeId'] as String?;
            final String? driverNote = extras['driverNote'] as String?;
            final int capacity = extras['capacity'] as int;
            return SlideRightTransition(
              child: RouteConfirmScreen(
                driverNote: driverNote,
                startLatitude: startLatitude ?? '',
                startLongitude: startLongitude ?? '',
                endLatitude: endLatitude ?? '',
                endLongitude: endLongitude ?? '',
                bookerId: bookerId ?? '',
                paymentMethod: paymentMethod ?? '0',
                carTypeId: carTypeId ?? '',
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.createDestination,
          path: RouteConstants.createDestinationUrl,
          pageBuilder: (context, state) {
            final Map<String, dynamic> params = state.pathParameters;
            final extras = state.extra as Map<String, dynamic>;
            final String destinationAddress =
                params['destinationAddress'] as String;
            final double latitude = extras['latitude'] as double;
            final double longitude = extras['longitude'] as double;
            return SlideRightTransition(
              child: CreateDestinationScreen(
                destinationAddress: destinationAddress,
                latitude: latitude,
                longitude: longitude,
              ), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.rating,
          path: RouteConstants.ratingUrl,
          pageBuilder: (context, state) {
            return SlideRightTransition(
              child:
                  const RateDriverScreen(), // Pass the phone parameter to OtpScreen
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.guardianObserveDependentTrip,
          path: RouteConstants.guardianObserveDependentTripUrl,
          pageBuilder: (context, state) {
            //final Map<String, dynamic> params = state.pathParameters;
            final extra = state.extra as Map<String, TripModel>;
            final trip = extra['trip'] as TripModel;
            return SlideRightTransition(
              child: GuardianObserveDependentTripScreen(
                trip: trip,
              ),
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          name: RouteConstants.dependentTripList,
          path: RouteConstants.dependentTripListUrl,
          pageBuilder: (context, state) {
            //final Map<String, dynamic> params = state.pathParameters;
            return SlideRightTransition(
              child: const DependentListTrip(),
              key: state.pageKey,
            );
          },
        ),
      ],
    );
  }
}

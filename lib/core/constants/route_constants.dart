class RouteConstants {
  ///**
  ///Route name constants
  /// */
  static const home = 'home';
  static const dashBoard = 'dashboard';
  static const otp = 'otp';
  static const passcode = 'passcode';
  static const carChoosing = 'car-choosing';
  static const searchTripRoute = 'search-trip-route';
  static const findTrip = 'find-trip';

  ///**
  ///Route url constants
  /// */
  static const homeUrl = '/home';
  static const dashBoardUrl = '/';
  static const signupUrl = '/sign-up';
  static const homeTripUrl = '/home-trip';
  static const connectToDriverUrl = '/connect-to-driver';
  static const otpUrl = '/otp/:phone';
  static const passcodeUrl = '/passcode/:setToken/:phone';
  static const carChoosingUrl =
      '/car-choosing/:startLongitude/:startLatitude/:endLongitude/:endLatitude';
  static const searchTripRouteUrl = '/search-trip-route';
  static const findTripUrl =
      '/find-trip/:startLongitude/:startLatitude/:endLongitude/:endLatitude';
}

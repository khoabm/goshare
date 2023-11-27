class RouteConstants {
  ///**
  ///Route name constants
  /// */
  static const home = 'home';
  static const signup = 'sign-up';
  static const login = 'log-in';
  static const dashBoard = 'dashboard';
  static const otp = 'otp';
  static const passcode = 'passcode';
  static const carChoosing = 'car-choosing';
  static const searchTripRoute = 'search-trip-route';
  static const findTrip = 'find-trip';
  static const dependentList = 'dependent-list';
  static const dependentAdd = 'dependent-add';
  static const dependentAddOtp = 'dependent-add-otp';
  static const driverPickUp = 'driver-pickup';
  static const chat = 'chat';
  static const routeConfirm = 'route-confirm';
  static const onTrip = 'on-trip';
  static const createDestination = 'create-destination';
  static const rating = 'rating';

  ///**
  ///Route url constants
  /// */
  static const homeUrl = '/home';
  static const dashBoardUrl = '/';
  static const signupUrl = '/sign-up';
  static const loginUrl = '/log-in';
  static const homeTripUrl = '/home-trip';
  static const connectToDriverUrl = '/connect-to-driver';
  static const otpUrl = '/otp/:phone/:isFor';
  static const passcodeUrl = '/passcode/:setToken/:phone/:isFor';
  static const carChoosingUrl =
      '/car-choosing/:startLongitude/:startLatitude/:endLongitude/:endLatitude';
  static const searchTripRouteUrl = '/search-trip-route';
  static const guardianObserveDependentTrip = 'guardian-observe';

  static const findTripUrl = '/find-trip';
  static const dependentListUrl = '/dependent-list';
  static const dependentAddUrl = '/dependent-add';
  static const dependentAddOtpUrl = '/dependent-add-otp';
  static const feedback = '/feedback';
  static const driverPickUpUrl = '/driver-pickup';

  static const chatUrl = '/chat/:receiver/:driverAvatar';
  static const routeConfirmUrl = '/route-confirm';
  static const onTripUrl = '/on-trip';
  static const createDestinationUrl = '/create-destination/:destinationAddress';

  static const editProfileUrl = '/edit-profile';
  static const moneyTopupUrl = '/money-topup';
  static const moneyHistoryUrl = '/money-history';

  static const ratingUrl = '/rating';

  static const guardianObserveDependentTripUrl = '/guardian-observe';
}

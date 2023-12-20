import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:goshare/core/failure.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/features/trip/repository/trip_repository.dart';

import 'package:goshare/models/car_model.dart';
import 'package:goshare/models/chat_model.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:goshare/models/trip_model.dart';

final tripControllerProvider = StateNotifierProvider<TripController, bool>(
  (ref) => TripController(
    tripRepository: ref.watch(tripRepositoryProvider),
    ref: ref,
  ),
);

class TripController extends StateNotifier<bool> {
  final TripRepository _tripRepository;
  final Ref _ref;
  TripController({
    required tripRepository,
    required Ref ref,
  })  : _tripRepository = tripRepository,
        _ref = ref,
        super(false);

  Future<TripModel?> findDriver(
      BuildContext context, FindTripModel tripModel) async {
    TripModel? trip;

    // final res =
    //     await _ref.watch(homeControllerProvider.notifier).searchLocationReverse(
    //           context,
    //           tripModel.startLongitude,
    //           tripModel.startLatitude,
    //         );
    // if (context.mounted) {
    //   final res2 = await _ref
    //       .watch(homeControllerProvider.notifier)
    //       .searchLocationReverse(
    //         context,
    //         tripModel.startLongitude,
    //         tripModel.startLatitude,
    //       );
    //   print(res.address);
    //   print(res2.address);
    //   tripModel.copyWith(
    //     endAddress: res.address,
    //     startAddress: res2.address,
    //   );
    // }

    final result = await _tripRepository.findDriver(tripModel);
    result.fold((l) {
      state = false;
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else if (l is AlreadyInTripFailure) {
        showAlreadyInTripError(
          context: context,
          message: l.message,
        );
      } else {
        showFindTripErrorDialog(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      trip = r;
    });
    return trip;
  }

  Future<TripModel?> findDriverForDependent(
    BuildContext context,
    FindTripModel tripModel,
    String dependentId,
  ) async {
    TripModel? trip;
    // final res =
    //     await _ref.watch(homeControllerProvider.notifier).searchLocationReverse(
    //           context,
    //           tripModel.startLongitude,
    //           tripModel.startLatitude,
    //         );
    // if (context.mounted) {
    //   final res2 = await _ref
    //       .watch(homeControllerProvider.notifier)
    //       .searchLocationReverse(
    //         context,
    //         tripModel.startLongitude,
    //         tripModel.startLatitude,
    //       );
    //   tripModel.copyWith(
    //     endAddress: res.address,
    //     startAddress: res2.address,
    //   );
    // }

    final result = await _tripRepository.findDriverForDependent(
      tripModel,
      dependentId,
    );
    result.fold((l) {
      state = false;
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else if (l is AlreadyInTripFailure) {
        showAlreadyInTripError(
          context: context,
          message: l.message,
        );
      } else {
        showFindTripErrorDialog(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      trip = r;
    });
    return trip;
  }

  Future<TripModel?> getTripInfo(
    BuildContext context,
    String tripId,
  ) async {
    TripModel? trip;

    final result = await _tripRepository.getTripInfo(
      tripId,
    );
    result.fold((l) {
      state = false;
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else if (l is AlreadyInTripFailure) {
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      trip = r;
    });
    return trip;
  }

  Future<List<CarModel>> getCarDetails(
    BuildContext context,
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    List<CarModel> list = [];
    final result = await _tripRepository.getCarDetails(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      print(r.length.toString());
      list = r;
    });
    return list;
  }

  Future<TripModel?> cancelTrip(BuildContext context, String tripId) async {
    TripModel? trip;
    final result = await _tripRepository.cancelTrip(tripId);
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      trip = r;
    });
    return trip;
  }

  Future<bool> sendChat(
    BuildContext context,
    String content,
    String receiver,
    String tripId,
  ) async {
    bool isSent = false;
    final result = await _tripRepository.sendChat(
      content,
      receiver,
      tripId,
    );
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      isSent = r;
    });
    return isSent;
  }

  Future<List<ChatModel>> getChat(
    BuildContext context,
    String tripId,
  ) async {
    List<ChatModel> chats = [];
    final result = await _tripRepository.getChat(
      tripId,
    );
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      chats = r;
    });
    return chats;
  }

  Future<double> getWallet(
    BuildContext context,
  ) async {
    double wallet = 0;
    final result = await _tripRepository.getWallet();
    result.fold((l) {
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      wallet = r;
    });
    return wallet;
  }

  Future<TripModel?> findDriverForNonAppDependent(
      BuildContext context, FindTripNonAppModel tripModel) async {
    TripModel? trip;

    final result =
        await _tripRepository.findDriverForNonAppDependent(tripModel);
    result.fold((l) {
      state = false;
      if (l is UnauthorizedFailure) {
        showLoginTimeOut(
          context: context,
        );
      } else if (l is AlreadyInTripFailure) {
        showAlreadyInTripError(
          context: context,
          message: l.message,
        );
      } else {
        showSnackBar(
          context: context,
          message: l.message,
        );
      }
    }, (r) {
      trip = r;
    });
    return trip;
  }
}

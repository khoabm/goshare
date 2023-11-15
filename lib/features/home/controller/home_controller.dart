import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/home/repositories/home_repository.dart';
import 'package:goshare/models/search_places_model.dart';
import 'package:goshare/models/vietmap_autocomplete_model.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);

  return HomeController(
    homeRepository: homeRepository,
  );
});
final searchPlaceProvider = StreamProvider.autoDispose
    .family<List<Place>, Map<String, dynamic>>((ref, params) {
  final homeController = ref.watch(homeControllerProvider.notifier);
  final query = params['query'];
  final format = params['format'] ?? 'jsonv2';
  final countryCodes = params['countryCodes'] ?? 'vn';
  final layer = params['layer'] ?? 'address';
  final addressdetails = params['addressdetails'] ?? 0;
  return homeController.searchPlace(
    query: query,
    format: format,
    countrycodes: countryCodes,
    layer: layer,
    addressdetails: addressdetails,
  );
});

class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository;
  HomeController({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(false);
  Future<List<VietmapAutocompleteModel>> searchLocation(
      BuildContext context, String keySearch) async {
    List<VietmapAutocompleteModel> list = [];

    final result = await _homeRepository.searchLocation(keySearch);
    result.fold(
      (l) {
        showSnackBar(
          context: context,
          message: l.message,
        );
      },
      (r) {
        list = r;
      },
    );
    return list;
  }

  Stream<List<Place>> searchPlace({
    required String query,
    String format = 'jsonv2',
    String countrycodes = 'vn',
    String layer = 'address',
    int addressdetails = 0,
  }) {
    return _homeRepository.searchPlaces(
      query,
      format,
      countrycodes,
      layer,
      addressdetails,
    );
  }
}
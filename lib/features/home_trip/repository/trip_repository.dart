import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:goshare/models/find_trip_model.dart';
import 'package:http/http.dart' as http;

class TripRepository {
  final String baseApiUrl;

  TripRepository({
    required this.baseApiUrl,
  });

  // FutureEither<List<String>?> searchPlaces(String prompt, String format, String countryCodes){
  //   try {

  //   } catch (e) {

  //   }
  // }

  FutureEither<bool> findDriver(FindTripModel tripModel) async {
    try {
      final endAddress = await placemarkFromCoordinates(
        tripModel.endLatitude,
        tripModel.endLongitude,
      );
      final startAddress = await placemarkFromCoordinates(
        tripModel.startLatitude,
        tripModel.startLongitude,
      );
      tripModel.copyWith(
        endAddress: endAddress.first.name,
        startAddress: startAddress.first.name,
      );
      Map<String, dynamic> tripModelMap = tripModel.toMap();
      //String tripModelJson = tripModel.toJson();
      final response = await http.post(
        Uri.parse(baseApiUrl),
        headers: {
          'Authorization': '',
          'Content-Type': 'application/json',
        },
        body: tripModelMap,
      );
      print(response.body);
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/constants/constants.dart';

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository(
    baseApiUrl: Constants.apiBaseUrl,
  );
});

class HomeRepository {
  final String baseApiUrl;

  HomeRepository({required this.baseApiUrl});

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buổi sáng tốt lành';
    } else if (hour < 17) {
      return 'Buổi trưa vui vẻ';
    }
    return 'Buổi tối tốt lành';
  }
}

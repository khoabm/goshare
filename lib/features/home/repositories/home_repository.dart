import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider((ref) {
  return HomeRepository();
});

class HomeRepository {
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

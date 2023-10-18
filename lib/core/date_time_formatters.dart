import 'package:intl/intl.dart';

class DateTimeFormatters {
  static DateTime convertStringToDate(String dateString) {
    final parsedDate = DateFormat('dd/MM/yyyy').parse(dateString);
    final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return DateTime.parse(formattedDate);
  }
}

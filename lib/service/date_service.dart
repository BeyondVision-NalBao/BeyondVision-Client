import 'package:intl/intl.dart';

class DateService {
  int convertDateToInt(DateTime selectedDay) {
    return selectedDay.weekday - 1;
  }

  String loginDate(DateTime now) {
    DateTime date = now.add(const Duration(days: 30));

    String formattedDate = DateFormat('yyyy-mm-dd').format(date);
    return formattedDate;
  }

  bool compareDate(String day) {
    DateTime standardDate = DateTime.parse(day);

    DateTime now = DateTime.now();

    if (now.isBefore(standardDate)) {
      return true;
    } else {
      return false;
    }
  }
}

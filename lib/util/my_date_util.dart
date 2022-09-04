import 'package:intl/intl.dart';

class MyDateUtils {
  static String alarmDateFormat(DateTime d) {
    final f = DateFormat('hh:mm a');
    return f.format(d);
  }
}

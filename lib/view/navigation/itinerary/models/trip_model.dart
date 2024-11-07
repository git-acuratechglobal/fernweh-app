import 'package:intl/intl.dart';

class Trip {
  String countryName;
  DateTime startTime;
  DateTime endTime;

  Trip(
      {required this.countryName,
      required this.startTime,
      required this.endTime});
  String get formattedDate {
    String formattedDate1 = DateFormat("dd/MM").format(startTime);
    String formattedDate2 = DateFormat("dd/MM").format(endTime);
    return "$formattedDate1-$formattedDate2";
  }
}

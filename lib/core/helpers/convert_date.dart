import 'package:intl/intl.dart';

String formatTimestamp(int timestamp, {bool showYear = false}) {
  // Convert the milliseconds timestamp to a DateTime object
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // Define the desired format
  DateFormat formatter = DateFormat('hh:mm a, MMM dd');

  DateFormat formatterWithYear = DateFormat('hh:mm a, MMM dd, yyyy');

  // Format the date and return it as a string
  return showYear ? formatterWithYear.format(date) : formatter.format(date);
}

// Helper function to safely convert numeric values to double
double? convertToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return null;
}

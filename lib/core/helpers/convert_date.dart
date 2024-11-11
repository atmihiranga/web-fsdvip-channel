import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  // Convert the milliseconds timestamp to a DateTime object
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // Define the desired format
  DateFormat formatter = DateFormat('hh:mm a, MMM dd');

  // Format the date and return it as a string
  return formatter.format(date);
}

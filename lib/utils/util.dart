import 'package:intl/intl.dart';

String formatLongDate(DateTime date) {
  return DateFormat("d MMMM y").format(date);
}
import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();

  var formatter = DateFormat.yMEd().add_jms();
  String formatted = formatter.format(now);

  return formatted;
}

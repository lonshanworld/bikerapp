import 'package:intl/intl.dart';

String changeNumberFormat(num value){
  final numformat = NumberFormat("#,##0", "en_US");
  return numformat.format(value);
}
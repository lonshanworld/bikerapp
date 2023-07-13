import 'package:intl/intl.dart';

String changeNumberFormat(num value){
  final numformat = NumberFormat("#,##0", "en_US");
  final numformatforpoint = NumberFormat("#,##0.00", "en_US");
  if(value == value.toInt()){
    return numformat.format(value);
  }else{
    return numformatforpoint.format(value);
  }
}
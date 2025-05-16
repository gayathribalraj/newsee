import 'package:intl/intl.dart';

String formatAmount(String amount) {
  try {
    final num value = num.parse(amount);
    final formatter = NumberFormat.decimalPattern('en_IN');
    return formatter.format(value);
  } catch (e) {
    return amount;
  }
}




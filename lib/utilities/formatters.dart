import 'package:intl/intl.dart';

final _formatter = NumberFormat.currency(
  locale: 'ro_RO',
  symbol: "",
  decimalDigits: 2,
);

String capitalize(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String amountFormat(double amount) {
  String formattedAmount = _formatter.format(amount);

  if (amount == amount.toInt()) {
    return formattedAmount.substring(0, formattedAmount.length - 4);
  }

  return formattedAmount.substring(0, formattedAmount.length - 1);
}

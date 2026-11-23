import 'package:intl/intl.dart';

String formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

String formatMoney(double v) =>
    NumberFormat.currency(locale: 'en_US', symbol: '\$').format(v);

String formatCompact(int n) => NumberFormat.compact().format(n);

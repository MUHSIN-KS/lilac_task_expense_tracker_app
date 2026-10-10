

import 'package:intl/intl.dart';

String money(double v) => '₹ ${NumberFormat('#,##0.00').format(v)}';

String fullDate(DateTime d) => DateFormat('EEE, d MMM yyyy').format(d);

String listDate(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('MMM d, yyyy').format(d);
}

String shortDate(DateTime d) => DateFormat('dd/MM/yy').format(d);
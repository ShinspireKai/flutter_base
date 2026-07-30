import 'package:flutter/widgets.dart';

import '../core/l10n/app_localizations.dart';

/// DateFormatter — helper format ngày kiểu 「2026/06/22（一）」
class DateFormatter {
  DateFormatter._();

  /// Nhãn thứ trong tuần theo ngôn ngữ hiện tại — index theo [DateTime.weekday] (1..7)
  static List<String> _weekdayLabels(AppLocalizations l10n) => [
    l10n.weekdayMon,
    l10n.weekdayTue,
    l10n.weekdayWed,
    l10n.weekdayThu,
    l10n.weekdayFri,
    l10n.weekdaySat,
    l10n.weekdaySun,
  ];

  /// Format [date] thành 'yyyy/MM/dd（weekday）'
  static String format(DateTime date, BuildContext context) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final weekday = _weekdayLabels(AppLocalizations.of(context)!)[date.weekday - 1];
    return '$y/$m/$d（$weekday）';
  }

  /// Ngày hiện tại đã format — gọi lại mỗi lần đọc để luôn đúng ngày thực tế
  static String today(BuildContext context) => format(DateTime.now(), context);
}

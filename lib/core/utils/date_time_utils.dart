import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String dateTimeFormatPattern = 'dd/MM/yyyy';

extension DateTimeExtension on DateTime {
  /// Return a string representing [date] formatted according to our locale
  String format({String? pattern = dateTimeFormatPattern, String? locale}) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}

extension TimeFormatExtension on TimeOfDay? {
  String? formatWithAMPM({bool force12Hour = true}) {
    if (this == null) {
      return null;
    }
    int hour = this!.hour;
    int minute = this!.minute;

    // If already in 12-hour format (e.g. from user input), leave as-is
    bool isAM = hour < 12;
    String period = isAM ? 'AM' : 'PM';

    // Convert 24-hour to 12-hour if needed
    int hour12 = hour % 12 == 0 ? 12 : hour % 12;

    // Format with leading zero if needed
    String formattedHour = hour12.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  DateTime? toDateTime() {
    if (this == null) {
      return null;
    }
    final cDay = DateTime.now();
    final d = DateTime(
      cDay.year,
      cDay.month,
      cDay.day,
      this?.hour ?? 0,
      this?.minute ?? 0,
      0,
      0,
      0,
    );
    return d;
  }
}

extension StringTimeOfDay on String? {
  TimeOfDay? convertToTimeOfDay() {
    String? timeString = this;
    if (timeString == null || timeString.isEmpty) {
      return null;
    }
    late DateTime dateTime;
    try {
      final DateFormat format = DateFormat.jm(); // 'h:mm a' format
      dateTime = format.parse(timeString.trim());
    } catch (e) {
      print(e);
      // print("Error 1");
      try {
        final DateFormat format = DateFormat('hh:mm:ss'); // 'h:mm a' format
        dateTime = format.parse(timeString.trim());
      } catch (e) {
        print(e);
        // print("Error 2");
        try {
          final DateFormat format = DateFormat('hh:mm a'); // 'h:mm a' format
          dateTime = format.parse(timeString.trim());
        } catch (e) {
          print(e);
          // print("Error 3 $timeString, length:- ${timeString.length}");
          final DateFormat format = DateFormat('hh:mm'); // 'h:mm a' format
          dateTime = format.parse(timeString.trim());
        }
      }
    }
    return TimeOfDay.fromDateTime(dateTime);
  }

  DateTime? stringToDate({String? pattern}) {
    String? date = this;
    if (date == null || date.isEmpty) {
      return null;
    }
    try {
      // DateFormat object to parse the time
      final DateFormat format = DateFormat(pattern ?? 'dd/MM/yyyy');

      // Parsing the time strings into DateTime objects
      DateTime dateTime = format.parse(date);

      return dateTime;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

import 'package:intl/intl.dart';
import 'package:expance/core/common.dart';

class MyDateFunctions {
  static String dateDifference(DateTime fromDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(fromDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 365) {
      final months =
          now.month - fromDate.month + (now.year - fromDate.year) * 12;
      return '$months months';
    } else {
      final years = now.year - fromDate.year;
      return '$years years';
    }
  }

  static Duration? timeDefference(DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null || toDate == null) {
      return null;
    }
    final ptrn = "hh:mm a";
    final fTime = fromDate.format(pattern: ptrn).stringToDate(pattern: ptrn);
    // print(fTime);
    final tTime = toDate.format(pattern: ptrn).stringToDate(pattern: ptrn);
    // print(tTime);
    final d = tTime!.difference(fTime!);
    return d;
  }

  static Duration? timeDefferenceString(
    String? fromDate,
    String? toDate, {
    String? pattern,
  }) {
    if (fromDate == null || toDate == null) {
      return null;
    }
    final ptrn = pattern ?? "hh:mm a";
    final fTime = fromDate.stringToDate(pattern: ptrn);
    final tTime = toDate.stringToDate(pattern: ptrn);
    final d = tTime!.difference(fTime!);
    return d;
  }

  static String? twoDateDifference(DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null || toDate == null) {
      return null;
    }

    // DateTime now = DateTime.now();
    DateTime now = toDate;
    Duration difference = toDate.difference(fromDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 365) {
      final months =
          now.month - fromDate.month + (now.year - fromDate.year) * 12;
      return '$months months';
    } else {
      final years = now.year - fromDate.year;
      return '$years years';
    }
  }

  static String? timeLeft(DateTime? fromDate) {
    if (fromDate == null) {
      return null;
    }
    final now = DateTime.now();
    Duration difference = fromDate.difference(now);
    if (difference.isNegative) {
      return null;
    }
    final sec = difference.inSeconds;
    final day = (sec ~/ 86400);
    final remSec = (sec % 86400);
    final hour = (remSec ~/ 3600);
    final remSec1 = (remSec % 3600);
    final minute = (remSec1 ~/ 60);
    final second = (remSec1 % 60);
    return "${day == 0 ? '' : "$day ${day == 1 ? 'day : ' : 'days : '}"}$hour:$minute:$second";
  }

  static String? dateToString({
    String? pattern,
    String? date,
    DateTime? dateTime,
  }) {
    final d = DateTime.tryParse(date ?? '');
    if (d != null) {
      return DateFormat(pattern ?? 'dd/MM/yyyy').format(d);
    } else {
      if (dateTime != null) {
        return DateFormat(pattern ?? 'dd/MM/yyyy').format(dateTime);
      } else {
        return date;
      }
    }
  }

  static DateTime? stringToDate(String? date) {
    if (date != null) {
      final d = DateTime.tryParse(date);
      if (d != null) {
        return d;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static int getDaysOfMonth(int month) {
    final year = DateTime.now().year;
    // Agar month 12 hai to agla month next year ka Jan hoga
    var nextMonth = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    // Ek din pehle se current month ka last day milega
    var lastDayOfMonth = nextMonth.subtract(Duration(days: 1));

    return lastDayOfMonth.day;
  }

  static showTimeInHHmmSSBySec(int second) {
    final hours = second ~/ 3600; // total hours
    final minutes =
        (second % 3600) ~/ 60; // hours ke baad bache hue seconds se minutes
    final seconds = second % 60; // remaining seconds

    return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }
}

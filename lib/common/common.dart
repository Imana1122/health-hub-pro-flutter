import 'package:intl/intl.dart';

String getTime(int value, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(
      DateTime.fromMillisecondsSinceEpoch(value * 60 * 1000, isUtc: true));
}

String getStringDateToOtherFormate(String dateStr,
    {String inputFormatStr = "yyyy-MM-ddTHH:mm:ss.SSSSSSZ",
    String outFormatStr = "hh:mm a"}) {
  var format = DateFormat(outFormatStr);
  return format.format(stringToDate(dateStr, formatStr: inputFormatStr));
}

DateTime stringToDate(String dateStr,
    {String formatStr = "yyyy-MM-ddTHH:mm:ss.SSSSSSZ"}) {
  try {
    // Removing the 'Z' at the end since it indicates UTC and it's not part of the format
    dateStr = dateStr.replaceAll('Z', '');
    var format = DateFormat(formatStr);
    return format.parse(dateStr);
  } catch (e) {
    // Handle parsing error, return current date as fallback
    print("Error parsing date: $e");
    return DateTime.now();
  }
}

DateTime dateToStartDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String dateToString(DateTime date, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(date);
}

String getDayTitle(String dateStr,
    {String formatStr = "yyyy-MM-ddTHH:mm:ss.SSSSSSZ"}) {
  try {
    var date = stringToDate(dateStr, formatStr: formatStr);

    if (date.isToday) {
      return "Today";
    } else if (date.isTomorrow) {
      return "Tomorrow";
    } else if (date.isYesterday) {
      return "Yesterday";
    } else {
      var outFormat = DateFormat("E");
      return outFormat.format(date);
    }
  } catch (e) {
    // Handle parsing error, return empty string as fallback
    print("Error getting day title: $e");
    return "";
  }
}

extension DateHelpers on DateTime {
  bool get isToday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 0;
  }

  bool get isYesterday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == -1;
  }

  bool get isTomorrow {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 1;
  }
}

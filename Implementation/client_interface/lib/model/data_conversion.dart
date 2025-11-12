class DataConversionServiceToModel {
  static String nullToEmptyString(String? value) {
    return value ?? '';
  }
}

class DataConversionModelToService {
  static String? toISO8601Date(DateTime? value) {
    return value?.toIso8601String().split('T').first;
  }

  static String toISO8601DateTime(DateTime dateTime) {
    final dateTimeString = dateTime.toUtc().toIso8601String();
    String offsetString = dateTime.timeZoneOffset.toString();
    if (offsetString[0] != '0') {
      offsetString = '0' + offsetString;
    }
    offsetString = (dateTime.timeZoneOffset.isNegative) ? '-' : '+' + offsetString;
    final iso8601FormattedDateTime = dateTimeString.substring(0, dateTimeString.length-1) + offsetString.substring(0, 6);
    return iso8601FormattedDateTime;
  }
}
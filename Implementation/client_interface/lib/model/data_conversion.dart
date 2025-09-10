class DataConversionServiceToModel {
  static String nullToEmptyString(String? value) {
    return value ?? '';
  }
}

class DataConversionModelToService {
  static String? dateTimeToDateString(DateTime? value) {
    return value?.toIso8601String().split('T').first;
  }
}
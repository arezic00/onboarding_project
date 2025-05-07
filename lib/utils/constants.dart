// API URLs
class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  static const String refreshAuth = '$baseUrl/auth/refresh';
  static const String currentAuthUrl = '$baseUrl/auth/me';
  static const String logsUrl =
      'https://raw.githubusercontent.com/json-iterator/test-data/master/large-file.json';
}

// Secure Storage Keys
class StorageKeys {
  static const String authDataKey = 'authData';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
}

// Configuration Values
class ConfigConstants {
  static const int tokenExpiryOffset = 30;
  static const int tokenExpiryMinutes = 10;
  static const int productsPageSize = 15;
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
}

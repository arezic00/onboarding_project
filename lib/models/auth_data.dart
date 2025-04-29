import '../utils/constants.dart';

class AuthData {
  final String accessToken;
  final String refreshToken;

  const AuthData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json[StorageKeys.accessToken],
      refreshToken: json[StorageKeys.refreshToken],
    );
  }

  Map<String, dynamic> toJson() => {
        StorageKeys.accessToken: accessToken,
        StorageKeys.refreshToken: refreshToken,
      };
}

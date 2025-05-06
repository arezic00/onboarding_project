import 'dart:convert';

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

  String get authHeader => 'Bearer $accessToken';

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadBytes = base64Url.decode(normalized);
    final payloadMap = json.decode(utf8.decode(payloadBytes));

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid JWT payload');
    }

    return payloadMap;
  }

  bool get isExpired {
    final jwtJsonMap = _decodeJwtPayload(accessToken);
    final exp = jwtJsonMap['exp'];
    final currentUtcSeconds = DateTime.now().millisecondsSinceEpoch / 1000;

    return currentUtcSeconds > exp - ConfigConstants.tokenExpiryOffset;
  }
}

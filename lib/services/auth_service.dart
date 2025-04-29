import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onboarding_project/models/auth_data.dart';
import 'package:onboarding_project/utils/constants.dart';

class AuthService {
  final Dio _dio = Dio();

  Map<String, dynamic> decodeJwtPayload(String token) {
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

  Future<AuthData> loginUser(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginUrl,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': ConfigConstants.tokenExpiryMinutes,
        },
      );

      if (response.statusCode == 200) {
        final authData = AuthData(
          accessToken: response.data[StorageKeys.accessToken],
          refreshToken: response.data[StorageKeys.accessToken],
        );

        return authData;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  bool expired(String jwtToken) {
    final jwtJsonMap = decodeJwtPayload(jwtToken);
    final exp = jwtJsonMap['exp'];
    final currentUtcSeconds = DateTime.now().millisecondsSinceEpoch / 1000;

    return currentUtcSeconds > exp - ConfigConstants.tokenExpiryOffset;
  }

  Future<AuthData> authCurrentUser(AuthData authData) async {
    try {
      if (!expired(authData.accessToken)) return authData;

      final newAuthData = await refreshAuth(authData.refreshToken);

      return newAuthData;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<AuthData> refreshAuth(String refreshToken) async {
    try {
      final response = await _dio.post(ApiConstants.refreshAuth,
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: {
            'refreshToken': refreshToken,
            'expiresInMins': ConfigConstants.tokenExpiryMinutes,
          });
      if (response.statusCode == 200) {
        return AuthData.fromJson(response.data);
      } else {
        throw Exception('Failed to refresh auth session');
      }
    } catch (e) {
      throw Exception('Error during refreshAuth: $e');
    }
  }
}

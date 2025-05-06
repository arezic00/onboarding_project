import 'package:onboarding_project/models/auth_data.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/dio_client.dart';
import 'package:onboarding_project/utils/constants.dart';

class AuthService {
  final DioClient _dioClient = getIt();

  Future<AuthData> loginUser(String username, String password) async {
    try {
      final response = await _dioClient.dioRequest(
        path: '/auth/login',
        method: 'POST',
        useAuthHeader: false,
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

  Future<AuthData> authCurrentUser(AuthData authData) async {
    try {
      if (!authData.isExpired) return authData;

      final newAuthData = await refreshAuth(authData.refreshToken);

      return newAuthData;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<AuthData> refreshAuth(String refreshToken) async {
    try {
      final response = await _dioClient.dioRequest(
        path: '/auth/refresh',
        method: 'POST',
        useAuthHeader: false,
        data: {
          'refreshToken': refreshToken,
          'expiresInMins': ConfigConstants.tokenExpiryMinutes,
        },
      );
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

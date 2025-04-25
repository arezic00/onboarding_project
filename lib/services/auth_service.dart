import 'package:dio/dio.dart';
import 'package:onboarding_project/services/secure_storage_service.dart';
import 'package:onboarding_project/utils/constants.dart';

class AuthService {
  final Dio _dio = Dio();
  final SecureStorageService _storageService = SecureStorageService();

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginUrl,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 10,
        },
      );

      if (response.statusCode == 200) {
        await _storageService.saveAccessToken(response.data['accessToken']);
        return response.data;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<String> authCurrentUser() async {
    try {
      final token = await _storageService.getAccessToken();

      final response = await _dio.get(
        ApiConstants.currentAuthUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return token!;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }
}

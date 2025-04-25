import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';

  Future<void> saveAccessToken(String token) async =>
      await _storage.write(key: accessTokenKey, value: token);

  Future<String?> getAccessToken() async =>
      await _storage.read(key: accessTokenKey);

  Future<void> saveRefreshToken(String token) async =>
      await _storage.write(key: refreshTokenKey, value: token);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: refreshTokenKey);
}

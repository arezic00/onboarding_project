import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_data.dart';
import '../utils/constants.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveAuthData(AuthData authData) async => await _storage.write(
      key: StorageKeys.authDataKey, value: authData.toJson());

  Future<AuthData?> getAuthData() async {
    final authData = await _storage.read(key: StorageKeys.authDataKey);
    if (authData != null) return AuthData.fromJson(authData);
    return null;
  }

  Future<void> deleteAuthData() async =>
      await _storage.delete(key: StorageKeys.authDataKey);
}

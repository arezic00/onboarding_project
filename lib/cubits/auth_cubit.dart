import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/auth_service.dart';
import 'package:onboarding_project/services/secure_storage_service.dart';

import '../models/auth_data.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthData authData;
  AuthAuthenticated(this.authData);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = SecureStorageService();
  final Logger logger = getIt();

  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final authData = await _authService.loginUser(username, password);
      _storageService.saveAuthData(authData);

      emit(AuthAuthenticated(authData));
    } catch (e) {
      logger.e('Error in AuthCubit.login()', error: e);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> authCurrentUser() async {
    emit(AuthLoading());

    try {
      final storedAuthData = await _storageService.getAuthData();
      if (storedAuthData == null) throw Exception('Missing stored auth data.');
      final authenticatedAuthData =
          await _authService.authCurrentUser(storedAuthData);
      _storageService.saveAuthData(authenticatedAuthData);
      emit(AuthAuthenticated(authenticatedAuthData));
    } catch (e) {
      logout();
    }
  }

  Future<bool>? _refreshTokenFuture;

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final result = await _authService.refreshAuth(refreshToken);
      emit(AuthAuthenticated(result));
      _storageService.saveAuthData(result);
      return true;
    } catch (e) {
      logger.d('refreshToken failed in AuthCubit: $e');
      logout();
      return false;
    }
  }

  Future<bool> tryRefreshToken(String token) async {
    logger.d('tryRefreshToken()...');
    logger.d('Refresh token: $token');
    logger.d('_refreshTokenFuture: $_refreshTokenFuture');
    _refreshTokenFuture ??= _refreshToken(token);
    final result = await _refreshTokenFuture;
    _refreshTokenFuture = null;
    return result ?? false;
  }

  AuthData? get authData {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).authData;
    }
    return null;
  }

  void logout() async {
    await _storageService.deleteAuthData();
    emit(AuthInitial());
  }
}

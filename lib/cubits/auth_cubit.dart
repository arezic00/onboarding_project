import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final authData = await _authService.loginUser(username, password);
      _storageService.saveAuthData(authData);

      emit(AuthAuthenticated(authData));
    } catch (e) {
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
      emit(AuthInitial());
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}

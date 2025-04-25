import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/models/user.dart';
import 'package:onboarding_project/services/auth_service.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();

  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final userData = await _authService.loginUser(username, password);

      final user = User.fromJson(userData);
      emit(AuthAuthenticated(user.accessToken));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> authCurrentUser() async {
    emit(AuthLoading());

    try {
      final token = await _authService.authCurrentUser();
      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}

import 'package:logger/logger.dart';
import 'package:onboarding_project/cubits/base_cubit.dart';
import 'package:onboarding_project/models/user.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/user_info_service.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final User user;

  UserInfoLoaded({required this.user});
}

class UserInfoError extends UserInfoState {
  final String message;

  UserInfoError({required this.message});
}

class UserInfoCubit extends BaseCubit<UserInfoState> {
  final _userInfoService = UserInfoService();
  final Logger _logger = getIt();
  UserInfoCubit() : super(UserInfoInitial());

  Future<void> getUserInfo() async {
    emit(UserInfoLoading());
    try {
      final user = await _userInfoService.getUser();
      _logger.d('User: $user');
      safeEmit(UserInfoLoaded(user: await _userInfoService.getUser()));
    } catch (e) {
      safeEmit(UserInfoError(message: 'UserInfoError: $e'));
    }
  }
}

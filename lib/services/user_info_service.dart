import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/dio_client.dart';

import '../models/user.dart';

class UserInfoService {
  final DioClient _dioClient = getIt();

  Future<User> getUser() async =>
      User.fromMap((await _dioClient.dioRequest(path: '/auth/me')).data);
}

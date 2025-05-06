import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/services/dio_client.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(() => AuthCubit());
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      getAuthCubitFunc: () => getIt<AuthCubit>(),
    ),
  );
  getIt.registerLazySingleton(
      () => Logger(printer: PrettyPrinter(noBoxingByDefault: true)));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/router.dart';
import 'package:onboarding_project/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();

  final AuthCubit authCubit = getIt();
  await authCubit.authCurrentUser();

  runApp(MainApp(authCubit: authCubit));
}

class MainApp extends StatelessWidget {
  final AuthCubit authCubit;
  const MainApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return authCubit;
      },
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}

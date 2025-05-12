import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/logs_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/cubits/user_info_cubit.dart';
import 'package:onboarding_project/screens/products_screen.dart';
import 'screens/home_screen.dart';
import 'screens/log_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_info_screen.dart';

final router = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
      redirect: (context, state) {
        if (context.read<AuthCubit>().state is AuthAuthenticated) {
          return '/products';
        }
        return null;
      },
    ),
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: '/products',
          builder: (context, state) => BlocProvider(
            create: (context) => ProductsCubit(),
            child: const ProductsScreen(),
          ),
        ),
        GoRoute(
            path: '/log',
            builder: (context, state) => BlocProvider(
                  create: (context) => LogsCubit()..getLogs(),
                  child: const LogScreen(),
                )),
      ],
    ),
    GoRoute(
        path: '/user-info',
        builder: (context, state) => BlocProvider(
              create: (context) => UserInfoCubit()..getUserInfo(),
              child: const UserInfoScreen(),
            )),
  ],
  redirect: (context, state) {
    if (state.uri.toString() != '/login' &&
        context.read<AuthCubit>().state is! AuthAuthenticated) {
      return '/login';
    }

    return null;
  },
);

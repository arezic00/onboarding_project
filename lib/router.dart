import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/logs_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/screens/products_screen.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/log_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_info_screen.dart';

final router = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
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
        builder: (context, state) => UserInfoScreen(
              user: User(
                  id: 1,
                  username: 'emilys',
                  email: 'emily.johnson@x.dummyjson.com',
                  firstName: 'Emily',
                  lastName: 'Johnson',
                  age: 26,
                  address: 'Ante Starčevića 44',
                  image: 'https://dummyjson.com/icon/emilys/128'),
            )),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final bool isAuthenticated = authState is AuthAuthenticated;

    //TODO: change from top level redirect to login specific redirect function
    if (state.uri.toString() == '/login' && isAuthenticated) {
      return '/products';
    }

    if (state.uri.toString() != '/login' && !isAuthenticated) {
      return '/login';
    }

    return null;
  },
);

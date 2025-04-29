import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/screens/products_screen.dart';
import 'screens/home_screen.dart';
import 'screens/log_screen.dart';
import 'screens/login_screen.dart';

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
        GoRoute(path: '/log', builder: (context, state) => const LogScreen()),
      ],
    ),
    //GoRoute(path: '/user-info', builder: (context, state) => UserInfoScreen()),
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

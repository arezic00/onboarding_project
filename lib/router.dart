import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/screens/products_screen.dart';
import 'screens/login_screen.dart';

final router = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    /* ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(path: '/products', builder: (context, state) => ProductsScreen()),
        GoRoute(path: '/logs', builder: (context, state) => LogsScreen()),
      ],
    ),
    GoRoute(path: '/user-info', builder: (context, state) => UserInfoScreen()), */
    GoRoute(
      path: '/products',
      builder: (context, state) => BlocProvider(
        create: (context) => ProductsCubit(),
        child: const ProductsScreen(),
      ),
    ),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final bool isAuthenticated = authState is AuthAuthenticated;

    print(state.uri.toString());
    print(isAuthenticated);

    if (state.uri.toString() == '/login' && isAuthenticated) {
      return '/products';
    }

    if (state.uri.toString() != '/login' && !isAuthenticated) {
      return '/login';
    }
  },
);

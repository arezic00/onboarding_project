import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user.dart';
import '../widgets/user_avatar.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child:
                  //state is AuthAuthenticatedState ?
                  UserAvatar(
                user: User(
                    id: 1,
                    username: 'emilys',
                    email: 'emily.johnson@x.dummyjson.com',
                    firstName: 'Emily',
                    lastName: 'Johnson',
                    age: 26,
                    address: 'Ante Starčevića 44',
                    image: 'https://dummyjson.com/icon/emilys/128'),
                onTap: () => context.go('/user-info'),
              )
              /*: state is AuthLoadingState
                        ? SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),*/
              ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: location.startsWith('/products') ? 0 : 1,
        onTap: (index) {
          context.go(index == 0 ? '/products' : '/log');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Log')
        ],
      ),
    );
  }
}

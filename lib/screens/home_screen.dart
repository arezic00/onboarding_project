import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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

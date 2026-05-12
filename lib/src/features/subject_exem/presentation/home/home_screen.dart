import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({super.key, required this.navigationShell});
  void _onTap(int index) {
    navigationShell.goBranch(
      index,

      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Đề thi'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}

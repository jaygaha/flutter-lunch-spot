import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback? onPressed;

  const BottomBar(
      {super.key, required this.selectedIndex, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [BottomNavigationBarItem(icon: Icon(Icons.hourglass_top))],
      currentIndex: selectedIndex,
    );
  }
}

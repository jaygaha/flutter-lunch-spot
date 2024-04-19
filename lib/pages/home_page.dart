import 'package:flutter/material.dart';
import 'package:lunchspot_v1/pages/dashboard_page.dart';
import 'package:lunchspot_v1/pages/restaurant_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    RestaurantPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LunchSpot',
          style: TextStyle(color: Color.fromRGBO(38, 70, 83, 1)),
        ),
        backgroundColor: const Color.fromRGBO(118, 200, 147, 1),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(118, 200, 147, 1),
        // elevation: 0,
        // iconSize: 30,
        // mouseCursor: SystemMouseCursors.grab,
        selectedItemColor: const Color.fromRGBO(38, 70, 83, 1),
        unselectedItemColor: const Color.fromRGBO(70, 113, 130, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded),
            label: 'Restaurant',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:recall/screens/home_screen.dart';
import 'package:recall/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.toggleTheme, required this.isDark});

  final Function(bool) toggleTheme;
  final bool isDark;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recall Memory Assistant")),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.home)
                : Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(Icons.person)
                : Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          ProfileScreen(toggleTheme: widget.toggleTheme, isDark: widget.isDark),
        ],
      ),
    );
  }
}

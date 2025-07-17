
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'timer_screen.dart';
import 'topics_screen.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _currentIndex = 1; // Default to Timer tab

  void _setTab (int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(changeTab: _setTab),
      TimerScreen(),
      TopicsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Topics',
          ),
        ],
      ),
    );
  }
}


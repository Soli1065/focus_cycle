import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'themes/theme.dart';

// Providers
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

void main() {
  runApp(
    const ProviderScope(
      child: FocusCycleApp(),
    ),
  );
}

class FocusCycleApp extends ConsumerWidget {
  const FocusCycleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'FocusCycle',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      home: const HomeScaffold(),
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentIndex = 1; // Default to Timer tab

  final _screens = const [
    DashboardScreen(),
    TimerScreen(),
    TopicsScreen(),
  ];

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

// Dummy Screens

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Dashboard Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Focus Timer Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Topics Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
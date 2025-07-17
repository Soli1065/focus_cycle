import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_cycle/ui/screens/base.dart';
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
      home: const Base(),
    );
  }
}




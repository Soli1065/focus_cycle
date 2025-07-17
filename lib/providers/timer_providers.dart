import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/topic.dart';

enum TimerMode { focus, breakTime }

final timerModeProvider = StateProvider<TimerMode>((ref) => TimerMode.focus);

final selectedTopicProvider = StateProvider<Topic?>((ref) => null);

final streakProvider = StateProvider<int>((ref) => 0);

final remainingTimeProvider = StateProvider<Duration>((ref) => const Duration(minutes: 25));

final timerRunningProvider = StateProvider<bool>((ref) => false);
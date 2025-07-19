import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/topic.dart';
import '../services/timer_service.dart';

enum TimerMode { focus, breakTime }

final timerServiceProvider = Provider<TimerService>((ref) {
  return TimerService(ref);
});

final timerModeProvider = StateProvider<TimerMode>((ref) => TimerMode.focus);

final selectedTopicProvider = StateProvider<Topic?>((ref) => null);

final remainingTimeProvider = StateProvider<Duration>((ref) => const Duration(minutes: 25));

final timerRunningProvider = StateProvider<bool>((ref) => false);
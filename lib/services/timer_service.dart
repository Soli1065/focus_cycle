import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/timer_providers.dart';

class TimerService {
  Timer? _timer;

  void start(WidgetRef ref) {
    if (_timer != null) return; // already running
    ref.read(timerRunningProvider.notifier).state = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = ref.read(remainingTimeProvider);
      if (current.inSeconds > 0) {
        ref.read(remainingTimeProvider.notifier).state =
            Duration(seconds: current.inSeconds - 1);
      } else {
        _switchMode(ref);
      }
    });
  }

  void pause(WidgetRef ref) {
    _timer?.cancel();
    _timer = null;
    ref.read(timerRunningProvider.notifier).state = false;
  }

  void reset(WidgetRef ref) {
    _timer?.cancel();
    _timer = null;
    ref.read(timerRunningProvider.notifier).state = false;
    ref.read(remainingTimeProvider.notifier).state = const Duration(minutes: 25);
  }

  void _switchMode(WidgetRef ref) {
    final mode = ref.read(timerModeProvider);
    if (mode == TimerMode.focus) {
      ref.read(timerModeProvider.notifier).state = TimerMode.breakTime;
      ref.read(remainingTimeProvider.notifier).state = const Duration(minutes: 5);
    } else {
      ref.read(timerModeProvider.notifier).state = TimerMode.focus;
      ref.read(remainingTimeProvider.notifier).state = const Duration(minutes: 25);
    }
  }
}
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/topic.dart';
import '../providers/timer_providers.dart';
import '../providers/topic_providers.dart';

class TimerService {
  final Ref ref;
  Timer? _timer;

  TimerService(this.ref);

  void start(WidgetRef ref) {
    if (_timer != null) return; // already running

    ref.read(timerRunningProvider.notifier).state = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = ref.read(remainingTimeProvider);
      if (current.inSeconds > 0) {
        ref.read(remainingTimeProvider.notifier).state =
            Duration(seconds: current.inSeconds - 1);
      } else {
        _onSessionComplete();
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
    ref.read(remainingTimeProvider.notifier).state =
    const Duration(minutes: 25);
  }

  void _onSessionComplete() {
    final selectedTopic = ref.read(selectedTopicProvider);

    // If a topic was selected, mark it reviewed
    if (selectedTopic != null) {
      ref
          .read(topicsProvider.notifier)
          .markTopicReviewed(selectedTopic.id);
    }

    // Increment streak
    ref.read(streakProvider.notifier).state++;

    // Switch mode and reset timer
    _switchMode();
  }

  void _switchMode() {
    final mode = ref.read(timerModeProvider);

    if (mode == TimerMode.focus) {
      ref.read(timerModeProvider.notifier).state = TimerMode.breakTime;
      ref.read(remainingTimeProvider.notifier).state =
      const Duration(minutes: 5);
    } else {
      ref.read(timerModeProvider.notifier).state = TimerMode.focus;
      ref.read(remainingTimeProvider.notifier).state =
      const Duration(minutes: 25);
    }
  }
}
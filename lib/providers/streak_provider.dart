import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final streakProvider = StateNotifierProvider<StreakNotifier, int>((ref) {
  return StreakNotifier();
});

class StreakNotifier extends StateNotifier<int> {
  final Box _box = Hive.box('streakBox');

  StreakNotifier() : super(0) {
    state = _box.get('streak', defaultValue: 0) as int;
  }

  void increment() {
    state++;
    _box.put('streak', state);
  }

  void reset() {
    state = 0;
    _box.put('streak', state);
  }
}
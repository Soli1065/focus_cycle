import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic.dart';

// Mocked topic list for now
final topicsProvider = StateProvider<List<Topic>>((ref) => []);

final todayReviewsProvider = Provider<List<Topic>>((ref) {
  final topics = ref.watch(topicsProvider);
  final today = DateTime.now();

  return topics.where((topic) {
    final nextReview = topic.nextReviewDate;
    return !nextReview.isAfter(DateTime(today.year, today.month, today.day));
  }).toList();
});
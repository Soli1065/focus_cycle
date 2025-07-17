import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic.dart';

final topicsProvider = StateProvider<List<Topic>>((ref) => []);

final todayReviewsProvider = Provider<List<Topic>>((ref) {
  final topics = ref.watch(topicsProvider);
  final today = DateTime.now();

  return topics.where((topic) {
    final nextReview = topic.nextReviewDate;
    return !nextReview.isAfter(DateTime(today.year, today.month, today.day));
  }).toList();
});


extension TopicsActions on WidgetRef {
  void addTopic(Topic topic) {
    read(topicsProvider.notifier).update((state) => [...state, topic]);
  }

  void editTopic(Topic updatedTopic) {
    read(topicsProvider.notifier).update((state) =>
        state.map((t) => t.id == updatedTopic.id ? updatedTopic : t).toList());
  }

  void deleteTopic(String id) {
    read(topicsProvider.notifier).update((state) =>
        state.where((t) => t.id != id).toList());
  }

  void markTopicReviewed(String id) {
    read(topicsProvider.notifier).update((state) => state.map((t) {
      if (t.id == id) {
        t.markReviewed();
      }
      return t;
    }).toList());
  }
}
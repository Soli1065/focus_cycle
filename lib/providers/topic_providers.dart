import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/topic.dart';

final topicsProvider =
StateNotifierProvider<TopicsNotifier, List<Topic>>((ref) {
  return TopicsNotifier();
});

class TopicsNotifier extends StateNotifier<List<Topic>> {
  final Box<Topic> _box = Hive.box<Topic>('topicsBox');

  TopicsNotifier() : super([]) {
    loadTopics();
  }

  void loadTopics() {
    state = _box.values.toList();
  }

  void addTopic(Topic topic) {
    _box.put(topic.id, topic);
    state = _box.values.toList();
  }

  void editTopic(Topic updatedTopic) {
    _box.put(updatedTopic.id, updatedTopic);
    state = _box.values.toList();
  }

  void deleteTopic(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }

  void markTopicReviewed(String id) {
    final topic = _box.get(id);
    if (topic != null) {
      topic.markReviewed();
      _box.put(topic.id, topic);
      state = _box.values.toList();
    }
  }
}

final todayReviewsProvider = Provider<List<Topic>>((ref) {
  final topics = ref.watch(topicsProvider);
  final today = DateTime.now();

  return topics.where((topic) {
    final nextReview = topic.nextReviewDate;
    return !nextReview.isAfter(DateTime(today.year, today.month, today.day));
  }).toList();
});

//
// extension TopicsActions on WidgetRef {
//   void addTopic(Topic topic) {
//     read(topicsProvider.notifier).update((state) => [...state, topic]);
//   }
//
//   void editTopic(Topic updatedTopic) {
//     read(topicsProvider.notifier).update((state) =>
//         state.map((t) => t.id == updatedTopic.id ? updatedTopic : t).toList());
//   }
//
//   void deleteTopic(String id) {
//     read(topicsProvider.notifier).update((state) =>
//         state.where((t) => t.id != id).toList());
//   }
//
//   void markTopicReviewed(String id) {
//     read(topicsProvider.notifier).update((state) => state.map((t) {
//       if (t.id == id) {
//         t.markReviewed();
//       }
//       return t;
//     }).toList());
//   }
// }
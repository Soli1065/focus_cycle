import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'topic.g.dart';

final _uuid = Uuid();

@HiveType(typeId: 0)
class Topic {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime? lastReviewedAt;

  @HiveField(4)
  int currentIntervalIndex;

  Topic({
    String? id,
    required this.name,
    DateTime? createdAt,
    this.lastReviewedAt,
    this.currentIntervalIndex = 0,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  static const List<int> reviewIntervals = [1, 3, 7, 14, 30];

  DateTime get nextReviewDate {
    if (lastReviewedAt == null) return createdAt.add(const Duration(days: 1));
    final days =
    reviewIntervals[currentIntervalIndex.clamp(0, reviewIntervals.length - 1)];
    return lastReviewedAt!.add(Duration(days: days));
  }

  void markReviewed() {
    lastReviewedAt = DateTime.now();
    if (currentIntervalIndex < reviewIntervals.length - 1) {
      currentIntervalIndex++;
    }
  }
}
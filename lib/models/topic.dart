import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class Topic {
  final String id;
  String name;
  DateTime createdAt;
  DateTime? lastReviewedAt;
  int currentIntervalIndex;

  Topic({
    String? id,
    required this.name,
    DateTime? createdAt,
    this.lastReviewedAt,
    this.currentIntervalIndex = 0,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Define spaced repetition intervals in days.
  static const List<int> reviewIntervals = [1, 3, 7, 14, 30];

  /// Calculate next review date based on current interval.
  DateTime get nextReviewDate {
    if (lastReviewedAt == null) return createdAt.add(const Duration(days: 1));
    final days = reviewIntervals[currentIntervalIndex.clamp(0, reviewIntervals.length - 1)];
    return lastReviewedAt!.add(Duration(days: days));
  }

  /// Call this when a review is completed
  void markReviewed() {
    lastReviewedAt = DateTime.now();
    if (currentIntervalIndex < reviewIntervals.length - 1) {
      currentIntervalIndex++;
    }
  }

  /// Serialize to Map (for Hive or Isar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'currentIntervalIndex': currentIntervalIndex,
    };
  }

  /// Deserialize from Map
  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      lastReviewedAt: map['lastReviewedAt'] != null
          ? DateTime.parse(map['lastReviewedAt'])
          : null,
      currentIntervalIndex: map['currentIntervalIndex'],
    );
  }
}
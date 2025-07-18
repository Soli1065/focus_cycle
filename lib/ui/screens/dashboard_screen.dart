import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/topic_providers.dart';
import '../../providers/timer_providers.dart';

class DashboardScreen extends ConsumerWidget {
  final void Function(int) changeTab;

  const DashboardScreen({super.key, required this.changeTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayReviews = ref.watch(todayReviewsProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusCycle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔥 Streak Card
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '🔥 $streak-day streak',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Keep it up!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 📆 Today’s Reviews
            Text(
              "Today's Reviews",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: todayReviews.isEmpty
                    ? const Center(
                  child: Text(
                    "✅ You're all caught up!\nNo reviews due today.",
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayReviews.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final topic = todayReviews[index];
                    return ListTile(
                      title: Text(topic.name),
                      subtitle: Text(
                        'Next review: ${topic.nextReviewDate.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          ref.read(topicsProvider.notifier).markTopicReviewed(topic.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Topic marked as reviewed')),
                          );
                        },
                        child: const Text('Review'),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 🚀 Quick Start
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => changeTab(1),
                icon: const Icon(Icons.timer),
                label: const Text('Start Focus Cycle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
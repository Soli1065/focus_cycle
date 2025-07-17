import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/topic_providers.dart';
import '../../providers/timer_providers.dart';
import '../screens/timer_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayReviews = ref.watch(todayReviewsProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusCycle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & streak
            Text(
              'Good Morning!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '🔥 $streak-day streak',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Today’s Reviews
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Reviews",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    todayReviews.isEmpty
                        ? const Text("✅ You're all caught up!")
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
                              'Next review: ${topic.nextReviewDate.toLocal().toString().split(' ')[0]}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // TODO: mark as reviewed
                            },
                            child: const Text('Review'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Quick Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Switch to Timer tab
                  DefaultTabController.of(context).animateTo(1);
                  // or navigate directly:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TimerScreen()),
                  );
                },
                child: const Text('Start Focus Cycle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/timer_providers.dart';
import '../../providers/topic_providers.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerService = ref.read(timerServiceProvider);
    final mode = ref.watch(timerModeProvider);
    final isTimerRunning = ref.watch(timerRunningProvider);
    final remainingTime = ref.watch(remainingTimeProvider);
    final selectedTopic = ref.watch(selectedTopicProvider);
    final streak = ref.watch(streakProvider);

    final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds.remainder(60)).toString().padLeft(2, '0');
    final progress = remainingTime.inSeconds /
        (mode == TimerMode.focus ? 25 * 60 : 5 * 60);


    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusCycle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  mode == TimerMode.focus ? 'Focus Session' : 'Break',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Icon(
                  mode == TimerMode.focus ? Icons.work : Icons.local_cafe,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),

            Card(
              child: ListTile(
                title: Text(
                  selectedTopic?.name ?? 'No topic selected',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: TextButton(
                  onPressed: () => _showTopicSelector(context, ref),
                  child: const Text('Select'),
                ),
              ),
            ),


            // Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  '$minutes:$seconds',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),

            // Topic Card
            // Card(
            //   child: ListTile(
            //     title: Text(
            //       selectedTopic?.name ?? 'No Topic Selected',
            //       style: Theme.of(context).textTheme.titleLarge,
            //     ),
            //     trailing: TextButton(
            //       onPressed: () {
            //         // TODO: Open topic selector
            //       },
            //       child: const Text('Change'),
            //     ),
            //   ),
            // ),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isTimerRunning) {
                      timerService.pause(ref);
                    } else {
                      timerService.start(ref);
                    }
                  },
                  child: Text(isTimerRunning ? 'Pause' : 'Start'),
                ),
                TextButton(
                  onPressed: () => timerService.reset(ref),
                  child: const Text('Reset'),
                ),
              ],
            ),

            // Streak Info
            Text(
              'Current Streak: 🔥 $streak',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicSelector(BuildContext context, WidgetRef ref) {
    final topics = ref.read(topicsProvider);

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return ListTile(
            title: Text(topic.name),
            onTap: () {
              ref.read(selectedTopicProvider.notifier).state = topic;
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
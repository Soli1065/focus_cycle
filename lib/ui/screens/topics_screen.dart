import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/topic_providers.dart';
import '../../models/topic.dart';

class TopicsScreen extends ConsumerWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        centerTitle: true,
      ),
      body: topics.isEmpty
          ? const Center(
        child: Text(
          'No topics yet.\nTap + to add your first one!',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(topic.name),
              subtitle: Text(
                'Next review: ${topic.nextReviewDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showAddEditDialog(context, ref, topic: topic);
                  } else if (value == 'delete') {
                    _showConfirmDeleteDialog(context, ref, topic.id);
                  } else if (value == 'review') {
                    ref.read(topicsProvider.notifier).markTopicReviewed(topic.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Topic marked as reviewed')),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'review', child: Text('Mark Reviewed')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {Topic? topic}) {
    final controller = TextEditingController(text: topic?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(topic == null ? 'Add Topic' : 'Edit Topic'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Topic name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              if (topic == null) {
                ref.read(topicsProvider.notifier).addTopic(Topic(name: name));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Topic added')),
                );
              } else {
                topic.name = name;
                ref.read(topicsProvider.notifier).editTopic(topic);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Topic updated')),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Topic'),
        content: const Text('Are you sure you want to delete this topic?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(topicsProvider.notifier).deleteTopic(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Topic deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
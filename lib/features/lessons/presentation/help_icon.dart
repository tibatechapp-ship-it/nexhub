import 'package:flutter/material.dart';

import '../data/lessons.dart';

class HelpIcon extends StatelessWidget {
  const HelpIcon({required this.topic, super.key});
  final String topic;

  @override
  Widget build(BuildContext context) {
    final lesson = lessons[topic];
    if (lesson == null) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.help_outline, size: 18),
      tooltip: 'شرح',
      visualDensity: VisualDensity.compact,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(lesson.title),
          content: SingleChildScrollView(child: Text(lesson.body)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('فهمت'),
            ),
          ],
        ),
      ),
    );
  }
}
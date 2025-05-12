import 'package:flutter/material.dart';
import 'package:onboarding_project/models/log_entry.dart';

class LogCard extends StatelessWidget {
  final LogEntry logEntry;

  const LogCard({super.key, required this.logEntry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(logEntry.type),
            Text(logEntry.username),
          ],
        ),
      ),
    );
  }
}

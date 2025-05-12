import 'dart:convert';
import 'dart:io';

import '../models/log_entry.dart';

List<LogEntry> _parseLogs(String json) => (jsonDecode(json) as List<dynamic>)
    .map((logMap) => LogEntry.fromMap(logMap))
    .toList();

List<LogEntry> parseLogsFromFile(String path) {
  final file = File(path);
  final json = file.readAsStringSync();
  return _parseLogs(json);
}

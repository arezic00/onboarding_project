import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:onboarding_project/models/log_entry.dart';
import 'package:onboarding_project/utils/parse_logs.dart';
import 'package:path_provider/path_provider.dart';

class LogService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl:
          'https://raw.githubusercontent.com/json-iterator/test-data/master'));

  Future<List<LogEntry>> getLogs() async {
    final response = await _dio.get('/large-file.json');
    final String json = response.data.toString();
    final directory = await getTemporaryDirectory();
    final file =
        await File('${directory.path}/large-json-temp.txt').writeAsString(json);
    return compute(parseLogsFromFile, file.path);
  }
}

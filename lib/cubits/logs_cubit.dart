import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/models/log_entry.dart';
import 'package:onboarding_project/services/log_service.dart';

abstract class LogsState {}

class LogsInitial extends LogsState {}

class LogsLoading extends LogsState {}

class LogsLoaded extends LogsState {
  final List<LogEntry> logs;

  LogsLoaded({required this.logs});
}

class LogsError extends LogsState {
  final String message;
  LogsError(this.message);
}

class LogsCubit extends Cubit<LogsState> {
  final _logService = LogService();
  LogsCubit() : super(LogsInitial());

  Future<void> getLogs() async {
    emit(LogsLoading());
    final logs = await _logService.getLogs();
    if (!isClosed) emit(LogsLoaded(logs: logs));
  }
}

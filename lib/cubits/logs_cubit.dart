import 'package:onboarding_project/cubits/base_cubit.dart';
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

class LogsCubit extends BaseCubit<LogsState> {
  final _logService = LogService();
  LogsCubit() : super(LogsInitial());

  Future<void> getLogs() async {
    emit(LogsLoading());
    final logs = await _logService.getLogs();
    safeEmit(LogsLoaded(logs: logs));
  }
}

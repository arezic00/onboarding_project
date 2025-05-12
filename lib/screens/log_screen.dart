import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/cubits/logs_cubit.dart';

import '../widgets/log_card.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogsCubit, LogsState>(
      listener: (context, state) => {},
      builder: (context, state) {
        if (state is LogsLoaded) {
          return ListView.builder(
              itemBuilder: (context, index) =>
                  LogCard(logEntry: state.logs[index]));
        } else if (state is LogsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LogsError) {
          return const Center(child: Text('Error'));
        } else {
          return const Center(child: Text('No logs'));
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/log_bloc.dart';
import '../blocs/log_event.dart';
import '../blocs/log_state.dart';
import 'widgets/log_entry.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  Future<void> _refreshLogs() async {
    context.read<LogBloc>().add(FetchLogs());
  }

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registros"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshLogs,
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: BlocBuilder<LogBloc, LogState>(
          builder: (context, state) {
            if (state is LogsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LogsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is LogsLoaded) {
              final logs = state.logs;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshLogs,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: logs.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            return LogEntry(log: log);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No logs available.'));
            }
          },
        ),
      ),
    );
  }
}

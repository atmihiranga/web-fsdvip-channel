import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/repositories/signal_stats_repository.dart';

class UpdateStatsDoc extends ConsumerWidget {
  const UpdateStatsDoc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: Text('Update Stats'),
      onPressed: () {
        SignalStatsRepository().updateStats();
      },
    );
  }
}

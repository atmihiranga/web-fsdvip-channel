import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/repositories/firestore_signal_stats.dart';

class Stats extends ConsumerWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.watch(firestoreSignalStatsProvider).tp1Count(),
        builder: (context, snap) {
          return Text('TP1 Count : ${snap.data.toString()}');
        });
  }
}

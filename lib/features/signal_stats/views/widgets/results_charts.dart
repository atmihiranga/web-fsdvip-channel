import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/models/data_points.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/repositories/signal_stats_repository.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/bar_chart.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/results_line_chart.dart';

class ResultsChart extends ConsumerWidget {
  const ResultsChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Map<String, List<DataPoint>>>(
        future: SignalStatsRepository().fetchResultsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            spacing: 20,
            children: [
              ResultsLineChart(
                  dataPoints: snapshot.data!['cumulativeDataPoints'] ?? []),

              //ResultsLineChart(dataPoints: snapshot.data!['dataPoints'] ?? []),
              BarChartWidget(dataPoints: snapshot.data!['dataPoints'] ?? [])
            ],
          );
        },
      ),
    );
  }
}

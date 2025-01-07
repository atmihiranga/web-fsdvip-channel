import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/viewmodels/signal_stats_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/custom_line_chart.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/custom_bar_chart.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/signals_stats_overview.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/update_stats_doc_button.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAdmin = false;
    final signalStats = ref.watch(signalStatsViewmodelProvider);
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    userAccountModel.whenData(
      (value) {
        isAdmin = value.isAdmin ?? false;
      },
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: signalStats.when(
        data: (data) {
          return Column(
            spacing: 20,
            children: [
              if (isAdmin) UpdateStatsDoc(),
              SignalsStatsOverview(
                signalStats: data,
              ),
              CustomLineChart(data: data.resultsMap),
              CustomBarChart(data: data.resultsMap)
            ],
          );
        },
        error: ((error, st) {
          return FailureWidget(
            message: error.toString(),
          );
        }),
        loading: () => LoadingWidget(),
      ),
    );
  }
}

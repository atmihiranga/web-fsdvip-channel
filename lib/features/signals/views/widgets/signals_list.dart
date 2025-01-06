import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/results_charts.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/views/widgets/get_stats.dart';
import 'package:project_3_forex_signals_daily/features/signals/viewmodels/signals_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/list_item_shimmer.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_widget.dart';

class ScrollState {
  final ScrollController controller = ScrollController();
  bool isLoadingMore = false;
}

class SignalsList extends ConsumerStatefulWidget {
  const SignalsList({super.key});

  @override
  ConsumerState<SignalsList> createState() => SignalsListState();
}

class SignalsListState extends ConsumerState<SignalsList> {
  // Initialize scroll states for each tab
  final _scrollStates = {
    'all': ScrollState(),
    'active': ScrollState(),
    'closed': ScrollState(),
  };

  @override
  void initState() {
    super.initState();
    // Add listeners for all scroll controllers
    _scrollStates.forEach((key, state) {
      state.controller.addListener(() => _onScroll(key));
    });
  }

  void _onScroll(String scrollStateKey) {
    final state = _scrollStates[scrollStateKey]!;
    if (!state.isLoadingMore &&
        state.controller.position.pixels >=
            state.controller.position.maxScrollExtent * 0.75) {
      state.isLoadingMore = true;
      ref
          .read(signalsViewmodelProvider.notifier)
          .fetchMoreSignals()
          .then((_) => state.isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var state in _scrollStates.values) {
      state.controller.dispose();
    }
    super.dispose();
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: LoadingWidget(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildSignalItem(SignalModel signal) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarker2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SignalWidget(signaldata: signal),
    );
  }

  Widget _buildSignalList(List<SignalModel?> signals, ScrollState scrollState) {
    return ListView.builder(
      controller: scrollState.controller,
      itemCount: signals.length + 1,
      itemBuilder: (context, index) {
        if (index == signals.length) {
          return _buildLoadingIndicator(scrollState.isLoadingMore);
        }
        return signals[index] != null
            ? _buildSignalItem(signals[index]!)
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return const ListTile(
      title: Text('No Active Signals'),
      subtitle: Text('All the signals are closed.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(signalsViewmodelProvider).when(
          data: (signalsList) {
            final activeSignals =
                signalsList.where((s) => s?.isActive == true).toList();
            final closedSignals =
                signalsList.where((s) => s?.isActive == false).toList();

            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.white,
                    indicatorColor: AppColors.white,
                    dividerHeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Active'),
                      Tab(text: 'Closed'),
                      Tab(text: 'Stats'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildSignalList(signalsList, _scrollStates['all']!),
                        activeSignals.isEmpty
                            ? _buildEmptyState()
                            : _buildSignalList(
                                activeSignals, _scrollStates['active']!),
                        _buildSignalList(
                            closedSignals, _scrollStates['closed']!),
                        SingleChildScrollView(
                          child: Column(
                            children: [ResultsChart()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => FailurePage(
            errorMessage: 'Error fetching signal data',
          ),
          loading: () => ListView.builder(
            itemCount: 5,
            itemBuilder: (context, _) => const ListItemShimmer(),
          ),
        );
  }
}

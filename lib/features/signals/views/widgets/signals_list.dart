import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/signals/models/signal_model.dart';
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
    return SignalWidget(signaldata: signal);
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDarker2,
        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withAlpha(30),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Open Date', 110),
          _buildHeaderCell('Close Date', 110),
          _buildHeaderCell('Symbol', 110),
          _buildHeaderCell('Signal Link', 100),
          _buildHeaderCell('Entry', 80),
          _buildHeaderCell('TP1', 80),
          _buildHeaderCell('TP2', 80),
          _buildHeaderCell('TP3', 80),
          _buildHeaderCell('SL', 80),
          _buildHeaderCell('Result', 90),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.white.withAlpha(150),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSignalList(List<SignalModel?> signals, ScrollState scrollState) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 960, // Total width: 920 (columns) + padding
          child: Column(
            children: [
              _buildTableHeader(),
              Expanded(
                child: ListView.builder(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_cellular_no_sim_rounded,
            size: 64,
            color: AppColors.white.withAlpha(50),
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Signals',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All the signals are closed.',
            style: TextStyle(
              color: AppColors.white.withAlpha(150),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
        ],
      ),
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
              length: 3,
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDarker3,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.white.withAlpha(100),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      indicator: BoxDecoration(
                        color: AppColors.blue.withAlpha(128),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      dividerHeight: 0,
                      tabs: [
                        _buildTab('All'),
                        _buildTab('Active'),
                        _buildTab('Closed'),
                      ],
                    ),
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
          loading: () => Center(
            child: LoadingWidget(),
          ),
        );
  }
}

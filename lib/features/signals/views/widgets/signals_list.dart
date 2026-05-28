import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/signals/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/features/signals/viewmodels/signals_viewmodel.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
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
          _buildHeaderCell('TP1', 100, addPadding: true),
          _buildHeaderCell('TP2', 100, addPadding: true),
          _buildHeaderCell('TP3', 100, addPadding: true),
          _buildHeaderCell('SL', 100, addPadding: true),
          _buildHeaderCell('Position Results', 150),
          _buildHeaderCell('PnL', 90),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width,
      {bool addPadding = false}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding:
            addPadding ? const EdgeInsets.only(left: 20.0) : EdgeInsets.zero,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSignalList(List<SignalModel?> signals, ScrollState scrollState) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1200,
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.signal_cellular_no_sim_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Signals',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All the signals are closed.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    return Tab(
      child: Text(label),
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      dividerHeight: 0,
                      tabs: [
                        _buildTab('All Signals'),
                        _buildTab('Active Now'),
                        _buildTab('History'),
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
          error: (error, stackTrace) => const FailurePage(
            errorMessage: 'Error fetching signal data',
          ),
          loading: () => const Center(
            child: LoadingWidget(),
          ),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/signals/viewmodels/signals_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/list_item_shimmer.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_widget.dart';

class SignalsList extends ConsumerStatefulWidget {
  const SignalsList({super.key});

  @override
  ConsumerState<SignalsList> createState() => _PremiumSignalsListState();
}

class _PremiumSignalsListState extends ConsumerState<SignalsList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isLoadingMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.75) {
      printDebug('=====> loading more');
      _isLoadingMore = true;
      ref
          .read(signalsViewmodelProvider.notifier)
          .fetchMoreSignals()
          .then((onValue) {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signalList = ref.watch(signalsViewmodelProvider);

    return signalList.when(
      data: (data) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Active'),
                  Tab(text: 'Closed'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      controller: _scrollController, // Attach the controller
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          // Display a loading indicator at the end of the list
                          return _isLoadingMore
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: LoadingWidget(),
                                  ),
                                )
                              : SizedBox.shrink();
                        }
                        if (data[index] != null) {
                          SignalModel signal = data[index]!;

                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundDarker2,
                              borderRadius: BorderRadius.circular(8),
                              // border: snapshot.data![index].isActive
                              //     ? Border(left: BorderSide(color: AppColors.blue))
                              //     : Border(),
                            ),
                            child: Column(
                              children: [
                                SignalWidget(
                                  signaldata: signal,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    Icon(Icons.directions_transit),
                    Icon(Icons.directions_bike),
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
        itemCount: 5, // Number of shimmer placeholders
        itemBuilder: (context, index) => ListItemShimmer(),
      ),
    );
  }
}

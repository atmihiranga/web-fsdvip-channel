import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/viewmodels/firestore_signals_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signal_widget.dart';

class PremiumSignalsList extends ConsumerStatefulWidget {
  const PremiumSignalsList({super.key});

  @override
  ConsumerState<PremiumSignalsList> createState() => _PremiumSignalsListState();
}

class _PremiumSignalsListState extends ConsumerState<PremiumSignalsList> {
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
          .read(firestoreSignalsViewmodelProvider.notifier)
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
    final signalList = ref.watch(firestoreSignalsViewmodelProvider);

    return signalList.when(
        data: (data) {
          return ListView.builder(
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
                      PremiumSignalWidget(
                        signaldata: data[index]!,
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
        error: (error, stackTrace) => FailurePage(),
        loading: () => Center(child: LoadingWidget()));
  }
}

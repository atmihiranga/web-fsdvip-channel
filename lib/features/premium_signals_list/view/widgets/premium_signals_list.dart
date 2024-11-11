import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/viewmodels/firestore_signals_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signal_widget.dart';

class PremiumSignalsList extends ConsumerWidget {
  const PremiumSignalsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signalList = ref.watch(firestoreSignalsViewmodelProvider);

    return signalList.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
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
                return Container();
              }
            },
          );
        },
        error: (error, stackTrace) => FailurePage(),
        loading: () => Center(child: LoadingWidget()));

    // return FutureBuilder(
    //     future: signalRepo.fetchSignalsFromFirestore(),
    //     builder: (context, snapshot) {
    //       printDebug('=====> premium_signals_list : ${snapshot.data}');
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: LoadingWidget(message: 'loading signals'));
    //       }
    //       if (!snapshot.hasData) {
    //         return Text('No Signals Available');
    //       }
    //       return ListView.builder(
    //         itemCount: snapshot.data!.length,
    //         itemBuilder: (context, index) {
    //           return Container(
    //             margin: const EdgeInsets.all(8.0),
    //             decoration: BoxDecoration(
    //               color: AppColors.backgroundDarker2,
    //               borderRadius: BorderRadius.circular(8),
    //               // border: snapshot.data![index].isActive
    //               //     ? Border(left: BorderSide(color: AppColors.blue))
    //               //     : Border(),
    //             ),
    //             child: Column(
    //               children: [
    //                 PremiumSignalWidget(
    //                   signaldata: snapshot.data![index],
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     });
  }
}

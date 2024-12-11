import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/chart/views/pages/chart_page.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/repositories/firebase_cloud_messaging_repository.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/viewmodels/firebase_cloud_messaging_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/pages/in_app_purchase_page.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.info)),
          userAccountModel.when(
            data: (user) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.workspace_premium,
                    color: user.isPremium ? AppColors.orange : AppColors.white,
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return SizedBox.shrink();
            },
            loading: () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                  baseColor: AppColors.white,
                  highlightColor: AppColors.orange,
                  child: Icon(
                    Icons.workspace_premium,
                  )),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Text('Filter'),
          //     ],
          //   ),
          // ),
          Expanded(
            child: const SignalsList(),
          ),
        ],
      ),
      drawer: const SideDrawer(),
    );
  }
}

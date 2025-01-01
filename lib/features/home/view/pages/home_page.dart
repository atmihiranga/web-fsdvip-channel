import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/ads/views/banner_ad.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/viewmodels/firebase_cloud_messaging_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/help/view/widgets/help.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/pages/in_app_purchase_page.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    ref.read(firebaseCloudMessagingViewmodelProvider);

    return userAccountModel.when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Forex Signals Daily'),
              actions: [
                Help(),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InAppPurchasePage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.workspace_premium,
                      color:
                          user.isPremium ? AppColors.orange : AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: const SignalsList(),
                ),
                BannerAdBottom(),
              ],
            ),
            drawer: SideDrawer(user),
          );
        },
        error: (error, stack) {
          return FailurePage(
            errorMessage: error.toString(),
          );
        },
        loading: () => LoadingPage());
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/pages/in_app_purchase_page.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
        actions: [
          userAccountModel.when(
            data: (user) {
              return InkWell(
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
              child: LoadingWidget(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: const SignalsList(),
          ),
        ],
      ),
      drawer: const SideDrawer(),
    );
  }
}

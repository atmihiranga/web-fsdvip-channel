import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/widgets/active_subscriptions.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/widgets/reguler_products.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class InAppPurchasePage extends ConsumerWidget {
  final String symbol;
  const InAppPurchasePage({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccount = ref.watch(userAccountViewmodelProvider);
    bool isPremium = false;
    userAccount.whenData(
      (value) {
        isPremium = value.isPremium;
      },
    );
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 36,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                isPremium
                    ? 'You are a Premium Member!'
                    : 'Become a Premium Member',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              ListTile(
                leading: Icon(
                  Icons.lock_open,
                  size: 32,
                ),
                title: Text('Unlock All Prices'),
                subtitle: Text(
                    'Unlock stoploss and take profit values for all the signals'),
              ),
              ListTile(
                leading: Icon(
                  Icons.tv_off,
                  size: 32,
                ),
                title: Text('Remove Ads'),
                subtitle: Text(
                    'Tired of ads ? premium subscription will remove all the ads'),
              ),
              RegularProducts(),
              ActiveSubscriptions()
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_purchase_view_model.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_active_subscriptions_viewmodel.dart';

class ActiveSubscriptions extends ConsumerWidget {
  const ActiveSubscriptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubscriptions =
        ref.watch(userActiveSubscriptionsViewmodelProvider);
    final inAppPurchases = ref.watch(inAppPurchaseViewModelProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Divider(),
          ListTile(
            title: Text(
              'Active Subscriptions',
            ),
            trailing: inAppPurchases.when(
                data: (data) {
                  return SizedBox.shrink();
                },
                error: (error, stackTrace) {
                  return SizedBox.shrink();
                },
                loading: () => LoadingWidget()),
          ),
          activeSubscriptions.when(
            data: (purchaseList) {
              if (purchaseList.isEmpty) {
                return ListTile(
                  title: Text(
                    'No active subscriptions.',
                  ),
                );
              }
              return Column(
                children: purchaseList
                    .map((element) => ListTile(
                          title: Text(element.productId),
                          subtitle: Text(
                              'Expires : ${formatTimestamp(element.expiryDate.toDate().millisecondsSinceEpoch, showYear: true)}'),
                        ))
                    .toList(),
              );
            },
            error: (error, stackTrace) {
              return FailureWidget(message: error.toString());
            },
            loading: () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: const LoadingWidget(),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              ref
                  .read(inAppPurchaseViewModelProvider.notifier)
                  .restorePurchases();
            },
            title: const Text('Restore Purchases'),
          ),
        ],
      ),
    );
  }
}

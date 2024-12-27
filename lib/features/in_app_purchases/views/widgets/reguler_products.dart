import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/helpers/extract_currency.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_products_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_purchase_view_model.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_active_subscriptions_viewmodel.dart';

class RegularProducts extends ConsumerWidget {
  const RegularProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetails = ref.watch(inAppProductsViewModelProvider);
    ref.watch(userActiveSubscriptionsViewmodelProvider);
    return productDetails.when(
        data: (productList) {
          final sortedProducts = productList.toList()
            ..sort((b, a) => b.rawPrice.compareTo(a.rawPrice));
          final double saving =
              (sortedProducts[0].rawPrice * 12 - sortedProducts[1].rawPrice) *
                  100 /
                  (sortedProducts[0].rawPrice * 12);
          return Column(
              children: sortedProducts.map((product) {
            switch (product.id) {
              case 'ffs_annual_subscription':
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.backgroundDarker2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        ref
                            .read(inAppPurchaseViewModelProvider.notifier)
                            .buySubscription(product);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.green),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      '~${extractCurrency(product.price)}${(product.rawPrice / 12).toStringAsFixed(2)}/month',
                                      style: TextStyle(color: AppColors.green)),
                                  SizedBox(width: 8),
                                  Container(
                                    color: AppColors.green.withAlpha(180),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    child: Text(
                                        'saving ${saving.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        )),
                                  ),
                                ],
                              ),
                              Text(
                                'Pay Yearly : ${product.price}/year',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(product.description),
                              SizedBox(height: 4),
                            ]),
                      ),
                    ),
                  ),
                );
              case 'ffs_monthly_subscription':
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.backgroundDarker2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        ref
                            .read(inAppPurchaseViewModelProvider.notifier)
                            .buySubscription(product);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.textSecondary),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pay Monthly : ${product.price}/month',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(product.description),
                              ]),
                        ),
                      ),
                    ),
                  ),
                );
              default:
                return SizedBox.shrink();
            }
          }).toList());
        },
        error: (error, stack) {
          return FailureWidget();
        },
        loading: () => LoadingWidget());
  }
}

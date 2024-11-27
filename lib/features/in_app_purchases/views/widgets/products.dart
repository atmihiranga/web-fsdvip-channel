import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_products_viewmodel.dart';

class Products extends ConsumerWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetails = ref.watch(inAppProductsViewModelProvider);
    return productDetails.when(
        data: (data) {
          return Column(
            children: data
                .map((product) => ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price),
                    ))
                .toList(),
          );
        },
        error: (error, stack) {
          return FailureWidget();
        },
        loading: () => LoadingWidget());
  }
}

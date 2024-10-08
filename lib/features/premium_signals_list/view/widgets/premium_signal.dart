import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/debug/random_list.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_more_details_row.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signal_title_row.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_sl_tp_price_data_row.dart';

class PremiumSignal extends ConsumerStatefulWidget {
  const PremiumSignal({super.key});

  @override
  ConsumerState<PremiumSignal> createState() => _PremiumSignalState();
}

bool isExpanded = false;

class _PremiumSignalState extends ConsumerState<PremiumSignal> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.backgroundDarker,
            shape: BoxShape.circle,
          ),
          child: getRandomItem([
            const Icon(
              Icons.trending_down,
              size: 24,
              color: AppColors.red,
            ),
            const Icon(
              Icons.trending_up,
              size: 24,
              color: AppColors.green,
            )
          ]),
        ),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
            printDebug('=====> isExpanded: $isExpanded');
          });
        },
        title: const SignalTitleRow(),
        subtitle: PremiumMoreDetailsRow(
          isExpanded: isExpanded,
        ),
        trailing: getRandomItem([
          const Text('active'),
          const Icon(Icons.check_circle, color: AppColors.green),
          const Icon(Icons.cancel, color: AppColors.red),
        ]),
        children: const <Widget>[
          SizedBox(height: 10),
          PremiumSLTPRow(label: 'Take Profit 1', price: '1.23456'),
          SizedBox(height: 4),
          PremiumSLTPRow(label: 'Take Profit 2', price: '1.23456'),
          SizedBox(height: 4),
          PremiumSLTPRow(label: 'Take Profit 3', price: '1.23456'),
          SizedBox(height: 4),
          PremiumSLTPRow(label: 'Stop Loss', price: '1.23456'),
        ],
      ),
    );
  }
}

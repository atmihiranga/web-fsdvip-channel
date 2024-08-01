import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/debug/random_list.dart';
import 'package:project_3_forex_signals_daily/features/premium_signal_widget/view/widgets/premium_more_details_row.dart';
import 'package:project_3_forex_signals_daily/features/signal_title_row/view/widgets/signal_title_row.dart';
import 'package:project_3_forex_signals_daily/features/premium_signal_widget/view/widgets/premium_sl_tp_price_data_row.dart';

class PremiumSignalWidget extends StatefulWidget {
  const PremiumSignalWidget({super.key});

  @override
  State<PremiumSignalWidget> createState() => _PremiumSignalWidgetState();
}

bool showDetails = false;

class _PremiumSignalWidgetState extends State<PremiumSignalWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory, // Disables the splash effect
      onTap: () {
        setState(() {
          showDetails = !showDetails;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
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
                const SizedBox(width: 10),
                const Expanded(child: SignalTitleRow()),
                const SizedBox(width: 10),
                getRandomItem([
                  const SpinKitThreeBounce(
                    color: AppColors.blue,
                    size: 20,
                  ),
                  const Icon(Icons.check_circle, color: AppColors.green),
                  const Icon(Icons.cancel, color: AppColors.red),
                ]),
              ],
            ),
            const SizedBox(height: 4),
            PremiumMoreDetailsRow(
              isExpanded: showDetails,
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: showDetails,
              child: const Column(
                children: [
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
            ),
          ],
        ),
      ),
    );
  }
}

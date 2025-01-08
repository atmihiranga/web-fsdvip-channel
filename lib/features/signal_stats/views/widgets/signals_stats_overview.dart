// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

import 'package:project_3_forex_signals_daily/features/signal_stats/models/signal_stats_model.dart';

class SignalsStatsOverview extends ConsumerWidget {
  final SignalStatsModel signalStats;
  const SignalsStatsOverview({
    super.key,
    required this.signalStats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColors.backgroundDarker2,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        spacing: 10,
        children: [
          Text(
            'Overview',
            style: TextStyle(fontSize: 24),
          ),
          Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        signalStats.closed.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'closed signals',
                        style: TextStyle(color: AppColors.whiteDisabled),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        ('+${signalStats.profitPips + signalStats.lossPips}')
                            .toString(),
                        style: TextStyle(fontSize: 20, color: AppColors.green),
                      ),
                      Text(
                        'cumulated pips',
                        style: TextStyle(color: AppColors.whiteDisabled),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Take Profit Hits'),
                  Text(('+${signalStats.profitPips} Pips').toString(),
                      style: TextStyle(color: AppColors.green))
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        // Use the default text style for the overall RichText
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '•TP1 ',
                            style: TextStyle(color: AppColors.whiteDisabled),
                          ),
                          TextSpan(
                            text: signalStats.tp1Hit.toString(),
                            // No style here, so it uses the default color
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        // Use the default text style for the overall RichText
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '•TP2 ',
                            style: TextStyle(color: AppColors.whiteDisabled),
                          ),
                          TextSpan(
                            text: signalStats.tp2Hit.toString(),
                            // No style here, so it uses the default color
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        // Use the default text style for the overall RichText
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '•TP3 ',
                            style: TextStyle(color: AppColors.whiteDisabled),
                          ),
                          TextSpan(
                            text: signalStats.tp3Hit.toString(),
                            // No style here, so it uses the default color
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(),
          Column(
            children: [
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Stop Loss Hits'),
                  Text(('${signalStats.lossPips} Pips').toString(),
                      style: TextStyle(color: AppColors.red))
                ],
              ),
              Text('•${(signalStats.slHit).toString()}'),
            ],
          ),
          Divider(),
          Text(
              style: TextStyle(color: AppColors.whiteDisabled),
              '•${signalStats.closed - (signalStats.slHit + signalStats.tp1Hit)} Signals has been closed without hitting Stop Loss or a Take Profit')
        ],
      ),
    );
  }
}

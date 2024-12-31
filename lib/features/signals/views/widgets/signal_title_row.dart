// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';

import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class SignalTitleRow extends ConsumerWidget {
  final SignalModel signaldata;

  const SignalTitleRow({
    super.key,
    required this.signaldata,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
          text: signaldata.symbol.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
          children: <TextSpan>[
            const TextSpan(text: ' '),
            TextSpan(
                text: signaldata.action.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: signaldata.action.toUpperCase() == 'BUY'
                        ? AppColors.green
                        : AppColors.red)),
            const TextSpan(text: ' '),
            TextSpan(text: '${signaldata.entry} '),
          ],
        )),
        Text('∙ ${formatTimestamp(signaldata.timestamp)}',
            style: TextStyle(fontSize: 12)),
        Row(
          spacing: 2,
          children: [
            Text('∙'),
            if (signaldata.isActive) Text('active'),
            if (signaldata.isTp1Hit)
              Container(
                  margin: EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.green.withAlpha(51)),
                  child: const Text(
                    ' TP1 ✓',
                    style: TextStyle(fontSize: 12, color: AppColors.green),
                  )),
            if (signaldata.isTp2Hit)
              Container(
                  margin: EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.green.withAlpha(51)),
                  child: const Text(
                    ' TP2 ✓',
                    style: TextStyle(fontSize: 12, color: AppColors.green),
                  )),
            if (signaldata.isTp3Hit)
              Container(
                  margin: EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.green.withAlpha(51)),
                  child: const Text(
                    ' TP3 ✓',
                    style: TextStyle(fontSize: 12, color: AppColors.green),
                  )),
            if (signaldata.isSlHit)
              Container(
                  margin: EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.red.withAlpha(51)),
                  child: const Text(
                    ' SL ',
                    style: TextStyle(fontSize: 12, color: AppColors.red),
                  )),
            if (signaldata.result != 0.0)
              Text(' ${signaldata.result > 0 ? '+' : ''}${signaldata.result}')
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/debug/random_list.dart';

class SignalTitleRow extends ConsumerWidget {
  const SignalTitleRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
          text: getRandomItem(['EURUSD', 'GBPUSD', 'USDJPY', 'AUDUSD']),
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            const TextSpan(text: ' '),
            TextSpan(
                text: getRandomItem(['BUY', 'SELL']),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getRandomItem([AppColors.green, AppColors.red]))),
            const TextSpan(text: ' '),
            const TextSpan(text: '1.23456 '),
          ],
        )),
        const SizedBox(
          height: 2,
        ),
        const Text('∙ 12:34 PM,Sep 22', style: TextStyle(fontSize: 12)),
        const SizedBox(
          height: 2,
        ),
        RichText(
          text: TextSpan(
              text:
                  '∙ ${getRandomItem(['Active', 'Closed +54', 'Closed -23'])}',
              style: const TextStyle(fontSize: 12)),
        )
      ],
    );
  }
}

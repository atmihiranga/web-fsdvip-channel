import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signals_list.dart';

class PremiumSignalsBody extends StatelessWidget {
  const PremiumSignalsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // It will cover 20% of our total height
        PremiumSignalsList()
      ],
    );
  }
}

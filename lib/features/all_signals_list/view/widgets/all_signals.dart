import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signal_widget.dart';

class AllSignals extends StatelessWidget {
  const AllSignals({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundDarker2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              PremiumSignalWidget(),
            ],
          ),
        );
      },
    );
  }
}

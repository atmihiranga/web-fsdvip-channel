import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class PremiumMoreDetailsRow extends ConsumerWidget {
  final bool isExpanded;

  const PremiumMoreDetailsRow({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.lightOpacity1,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Row(
                children: <Widget>[
                  Icon(size: 16, Icons.candlestick_chart),
                  SizedBox(width: 4),
                  Text('Chart'),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Icon(
              applyTextScaling: true,
              isExpanded ? Icons.expand_less : Icons.expand_more,
              // size: 16,
            ),
            const SizedBox(width: 4),
            const Text('SL/TP'),
          ],
        ),
      ],
    );
  }
}

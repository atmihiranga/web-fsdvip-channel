import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class SignalButtonsRow extends ConsumerWidget {
  final bool isExpanded;

  const SignalButtonsRow({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.lightOpacity1,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(size: 14, Icons.candlestick_chart),
                  SizedBox(width: 4),
                  Text(
                    'Chart',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.lightOpacity1,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(size: 14, Icons.auto_graph),
                  SizedBox(width: 4),
                  Text(
                    'Analysis',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.lightOpacity1,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(size: 14, Icons.info_outline),
                  SizedBox(width: 4),
                  Text(
                    'Note',
                    style: TextStyle(fontSize: 12),
                  ),
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
            const Text(
              'SL/TP',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

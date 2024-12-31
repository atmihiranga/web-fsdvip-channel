import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/helpers/show_snackbar.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/chart/views/pages/chart_page.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/pages/analysis_page.dart';

class SignalButtonsRow extends ConsumerWidget {
  final bool isExpanded;
  final String symbol;
  final String analysisLink;
  final String note;
  final bool isLocked;

  const SignalButtonsRow({
    super.key,
    required this.isExpanded,
    required this.symbol,
    required this.analysisLink,
    required this.note,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.backgroundDarker3,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChartPage(
                    symbol: symbol,
                  ),
                ),
              );
            },
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
          color: isLocked
              ? AppColors.backgroundDarker3
              : analysisLink == ''
                  ? AppColors.backgroundDarker3.withAlpha(120)
                  : AppColors.backgroundDarker3,
          child: InkWell(
            onTap: () {
              if (isLocked) {
                showSnackBarMessage(
                  context: context,
                  message:
                      'Analysis Chart for this signal is only available for Premium Members.',
                  duration: Duration(seconds: 3),
                  backgroundColor: AppColors.red,
                  textColor: AppColors.white,
                );
              } else {
                if (analysisLink == '') {
                  showSnackBarMessage(
                    context: context,
                    message:
                        'Analysis Chart is not ready yet or signal is too old.',
                    duration: Duration(seconds: 3),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalysisPage(
                        analysisLink: analysisLink,
                      ),
                    ),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(
                      size: 14,
                      isLocked ? Icons.lock_open_outlined : Icons.auto_graph,
                      color: isLocked
                          ? AppColors.white
                          : analysisLink == ''
                              ? AppColors.white.withAlpha(120)
                              : AppColors.white),
                  SizedBox(width: 4),
                  Text(
                    'Analysis',
                    style: TextStyle(
                        fontSize: 12,
                        color: isLocked
                            ? AppColors.white
                            : analysisLink == ''
                                ? AppColors.white.withAlpha(120)
                                : AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(6),
          color: note.trim() == ''
              ? AppColors.backgroundDarker3.withAlpha(120)
              : AppColors.backgroundDarker3,
          child: InkWell(
            onTap: () {
              if (note.trim() == '') {
                showSnackBarMessage(
                  context: context,
                  message: 'No notes for this signal.',
                  duration: Duration(seconds: 3),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text('$symbol Note'),
                      content: Text(note),
                      actions: [
                        TextButton(
                          child: Text('close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(
                      size: 14,
                      Icons.info_outline,
                      color: note.trim() == ''
                          ? AppColors.white.withAlpha(120)
                          : AppColors.white),
                  SizedBox(width: 4),
                  Text(
                    'Note',
                    style: TextStyle(
                        fontSize: 12,
                        color: note.trim() == ''
                            ? AppColors.white.withAlpha(120)
                            : AppColors.white),
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

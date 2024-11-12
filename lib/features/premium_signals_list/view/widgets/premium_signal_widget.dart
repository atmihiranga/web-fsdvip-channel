// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';

import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/views/pages/edit_signal_page.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_more_details_row.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signal_title_row.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_sl_tp_price_data_row.dart';

class PremiumSignalWidget extends ConsumerStatefulWidget {
  final SignalModel signaldata;

  const PremiumSignalWidget({
    super.key,
    required this.signaldata,
  });

  @override
  ConsumerState<PremiumSignalWidget> createState() =>
      _PremiumSignalWidgetState();
}

bool showDetails = false;

class _PremiumSignalWidgetState extends ConsumerState<PremiumSignalWidget> {
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
                    child: widget.signaldata.action.toUpperCase() == 'BUY'
                        ? const Icon(
                            Icons.trending_up,
                            size: 24,
                            color: AppColors.green,
                          )
                        : const Icon(Icons.trending_down,
                            size: 24, color: AppColors.red)),
                const SizedBox(width: 10),
                Expanded(
                    child: SignalTitleRow(
                  signaldata: widget.signaldata,
                )),
                const SizedBox(width: 10),
                widget.signaldata.isActive
                    ? Text('active')
                    : widget.signaldata.result < 0
                        ? const Icon(Icons.cancel, color: AppColors.red)
                        : const Icon(Icons.check_circle,
                            color: AppColors.green),
              ],
            ),
            const SizedBox(height: 4),
            PremiumMoreDetailsRow(
              isExpanded: showDetails,
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: showDetails,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  PremiumSLTPRow(
                      label: 'Take Profit 1',
                      price: widget.signaldata.tp1.toString()),
                  SizedBox(height: 4),
                  PremiumSLTPRow(
                      label: 'Take Profit 2',
                      price: widget.signaldata.tp2.toString()),
                  SizedBox(height: 4),
                  PremiumSLTPRow(
                      label: 'Take Profit 3',
                      price: widget.signaldata.tp3.toString()),
                  SizedBox(height: 4),
                  PremiumSLTPRow(
                      label: 'Stop Loss',
                      price: widget.signaldata.sl.toString()),
                  TextButton(
                      onPressed: () {
                        // _showMyDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSignalPage(signalData: widget.signaldata),
                          ),
                        );
                      },
                      child: Text('edit'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

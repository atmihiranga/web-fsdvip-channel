import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';
import 'package:project_3_forex_signals_daily/features/update_signal/views/pages/update_signal_data.dart';

class PremiumUserMoreSignalDetails extends StatelessWidget {
  const PremiumUserMoreSignalDetails({
    super.key,
    required this.signaldata,
  });

  final SignalModel signaldata;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SlTpPriceRow(
          priceLabel: 'Take Profit 1',
          price: signaldata.tp1.toString(),
          isLocked: false,
        ),
        SizedBox(height: 4),
        SlTpPriceRow(
          priceLabel: 'Take Profit 2',
          price: signaldata.tp2.toString(),
          isLocked: false,
        ),
        SizedBox(height: 4),
        SlTpPriceRow(
          priceLabel: 'Take Profit 3',
          price: signaldata.tp3.toString(),
          isLocked: false,
        ),
        SizedBox(height: 4),
        SlTpPriceRow(
          priceLabel: 'Stop Loss',
          price: signaldata.sl.toString(),
          isLocked: false,
        ),
      ],
    );
  }
}

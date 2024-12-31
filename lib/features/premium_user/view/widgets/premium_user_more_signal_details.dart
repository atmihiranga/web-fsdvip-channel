import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';

class PremiumUserMoreSignalDetails extends StatelessWidget {
  const PremiumUserMoreSignalDetails({
    super.key,
    required this.signaldata,
  });

  final SignalModel signaldata;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        SizedBox(height: 6),
        SlTpPriceRow(
          priceLabel: 'Take Profit 1',
          price: signaldata.tp1.toString(),
          isLocked: false,
          isHit: signaldata.isTp1Hit,
        ),
        SlTpPriceRow(
          priceLabel: 'Take Profit 2',
          price: signaldata.tp2.toString(),
          isLocked: false,
          isHit: signaldata.isTp2Hit,
        ),
        SlTpPriceRow(
          priceLabel: 'Take Profit 3',
          price: signaldata.tp3.toString(),
          isLocked: false,
          isHit: signaldata.isTp3Hit,
        ),
        SlTpPriceRow(
          priceLabel: 'Stop Loss',
          price: signaldata.sl.toString(),
          isLocked: false,
          isHit: signaldata.isSlHit,
        ),
      ],
    );
  }
}

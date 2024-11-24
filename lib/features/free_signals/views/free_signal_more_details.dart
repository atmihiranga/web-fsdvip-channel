import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';

class SignalMoreDetailsLocked extends StatelessWidget {
  const SignalMoreDetailsLocked({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SlTpPriceRow(label: 'Take Profit 1', price: 'Locked'),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Take Profit 2', price: 'Locked'),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Take Profit 3', price: 'Locked'),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Stop Loss', price: 'Locked'),
      ],
    );
  }
}

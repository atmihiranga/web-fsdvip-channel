import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';

class FreeUserMoreSignalDetails extends StatelessWidget {
  const FreeUserMoreSignalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        SizedBox(height: 6),
        SlTpPriceRow(
          priceLabel: 'Take Profit 1',
          price: 'Locked',
          isLocked: true,
          isHit: false,
        ),
        SlTpPriceRow(
          priceLabel: 'Take Profit 2',
          price: 'Locked',
          isLocked: true,
          isHit: false,
        ),
        SlTpPriceRow(
          priceLabel: 'Take Profit 3',
          price: 'Locked',
          isLocked: true,
          isHit: false,
        ),
        SlTpPriceRow(
          priceLabel: 'Stop Loss',
          price: 'Locked',
          isLocked: true,
          isHit: false,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';
import 'package:project_3_forex_signals_daily/features/update_signal/views/pages/update_signal_data.dart';

class SignalMoreDetailsUnlocked extends StatelessWidget {
  const SignalMoreDetailsUnlocked({
    super.key,
    required this.signaldata,
  });

  final SignalModel signaldata;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SlTpPriceRow(label: 'Take Profit 1', price: signaldata.tp1.toString()),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Take Profit 2', price: signaldata.tp2.toString()),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Take Profit 3', price: signaldata.tp3.toString()),
        SizedBox(height: 4),
        SlTpPriceRow(label: 'Stop Loss', price: signaldata.sl.toString()),
        SizedBox(
          width: double.infinity,
          child: TextButton(
              onPressed: () {
                // _showMyDialog();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateSignalDataPage(signalData: signaldata),
                  ),
                );
              },
              child: Icon(Icons.edit)),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/chart/views/widgets/chart.dart';

class ChartPage extends StatelessWidget {
  final String symbol;
  const ChartPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$symbol Chart'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Chart(
            symbol: symbol,
          ))
        ],
      ),
    );
  }
}

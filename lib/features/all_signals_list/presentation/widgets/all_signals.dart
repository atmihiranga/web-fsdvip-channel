import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/free_signal/presentation/widgets/free_signal.dart';

class AllSignals extends StatelessWidget {
  const AllSignals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Signals'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const FreeSignal();
        },
      ),
    );
  }
}

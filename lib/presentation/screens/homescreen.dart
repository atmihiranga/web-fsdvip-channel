import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/all_signals_list/presentation/widgets/all_signals.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
      ),
      body: const AllSignals(),
    );
  }
}

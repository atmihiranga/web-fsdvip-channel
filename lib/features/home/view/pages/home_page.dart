import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_all_signals.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
      ),
      body: const PremiumAllSignals(),
      drawer: const SideDrawer(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals_list/view/widgets/premium_signals_list.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
      ),
      body: const PremiumSignalsList(),
      drawer: const SideDrawer(),
    );
  }
}

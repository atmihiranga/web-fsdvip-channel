import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/side_drawer.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _userAccount = ref.watch(userAccountViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex Signals Daily'),
        actions: [
          Text(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset('assets/lottie/premium-true.json'),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: const SignalsList(),
          ),
        ],
      ),
      drawer: const SideDrawer(),
    );
  }
}

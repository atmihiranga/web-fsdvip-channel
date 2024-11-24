import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class UserAccountWidget extends ConsumerWidget {
  const UserAccountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccount = ref.watch(userAccountViewmodelProvider);
    return userAccount.when(
        data: (data) {
          return Column(
            children: [
              ListTile(
                title: Text(data.id),
              ),
              ListTile(
                title: Text(data.isPremium.toString()),
              ),
              ListTile(
                title: Text(data.installedTimestamp.toString()),
              )
            ],
          );
        },
        error: (error, stack) {
          return FailurePage(
            errorMessage: e.toString(),
          );
        },
        loading: () => LoadingWidget());
  }
}

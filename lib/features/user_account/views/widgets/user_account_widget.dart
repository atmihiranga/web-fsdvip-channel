import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
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
                title: Text('ID'),
                subtitle: Text(data.id),
              ),
              ListTile(
                title: Text('Is Premium ?'),
                subtitle: Text(data.isPremium.toString()),
              ),
              ListTile(
                title: Text('Installed on'),
                subtitle: Text(formatTimestamp(data.installedTimestamp)),
              ),
              ListTile(
                title: Text('fcm token'),
                subtitle: Text(data.fcmToken),
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

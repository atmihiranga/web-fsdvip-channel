import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/view_models/connectivity_check_viewmodell.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/views/pages/no_internet_page.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/view_models/firebase_anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/home/view/pages/home_page.dart';

class FsdApp extends ConsumerWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetConnection = ref.watch(connectivityViewModelProvider);

    final isLoading = ref.watch(authViewModelProvider).isLoading;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: internetConnection.when(
        data: (isConnected) {
          if (isConnected) {
            return isLoading
                ? const LoadingWidget(
                    message: 'Authenticating',
                  )
                : const HomePage();
          } else {
            return const NoInternetPage();
          }
        },
        loading: () => const LoadingPage(),
        error: (error, stackTrace) => const FailurePage(),
      ),
    );
  }
}

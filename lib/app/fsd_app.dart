import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/view_models/connectivity_check_viewmodell.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/views/pages/no_internet_page.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/home/view/pages/home_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme_provider.dart';

class FsdApp extends ConsumerWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetConnection = ref.watch(connectivityViewModelProvider);
    final authentication = ref.watch(authViewModelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
        title: 'Forex Signals Daily',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: kIsWeb
            ? HomePage()
            : internetConnection.when(
                data: (isConnected) {
                  return isConnected
                      ? authentication.when(
                          data: (userData) {
                            return HomePage();
                          },
                          error: (error, stackTrace) {
                            return FailurePage(
                              errorMessage: error.toString(),
                            );
                          },
                          loading: () => LoadingPage())
                      : NoInternetPage();
                },
                error: (error, stackTrace) {
                  return FailurePage();
                },
                loading: () => LoadingPage()));
  }
}

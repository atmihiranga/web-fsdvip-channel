import 'dart:io';

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
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_purchase_view_model.dart';

class FsdApp extends ConsumerWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.watch(connectivityRepositoryProvider);
    final internetConnection = ref.watch(connectivityViewModelProvider);
    final authentication = ref.watch(authViewModelProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: kIsWeb
            ? HomePage()
            : internetConnection.when(
                data: (isConnected) {
                  return isConnected
                      ? authentication.when(
                          data: (userData) {
                            // we initialize iap when android user first open the app, this calls 'restore purchases' function
                            // iOS guidlines says to not to do this on app launch, so we're avoiding iOS
                            if (Platform.isAndroid) {
                              ref.read(inAppPurchaseViewModelProvider);
                            }
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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/repositories/connectivity_repository.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/view_models/connectivity_check_viewmodell.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/views/pages/no_internet_page.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/view_models/firebase_anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/home/view/pages/home_page.dart';

class FsdApp extends ConsumerWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(connectivityRepositoryProvider);
    final authentication = ref.watch(authViewModelProvider);
    final internetConnection = ref.watch(connectivityViewModelProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: internetConnection.when(
            data: (isConnected) {
              return isConnected
                  ? authentication.when(
                      data: (userData) {
                        printDebug('=====> uid : ${userData!.uid}');
                        return HomePage();
                      },
                      error: (error, stackTrace) {
                        return FailurePage();
                      },
                      loading: () => LoadingPage())
                  : NoInternetPage();
            },
            error: (error, stackTrace) {
              return FailurePage();
            },
            loading: () => LoadingPage())
        // StreamBuilder(
        //   // first check internet connection
        //   stream: connectivityRepo.connectivityStatus(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return LoadingPage();
        //     }
        //     // Check if snapshot.data is null or if it contains ConnectivityResult.none
        //     if (snapshot.data == null ||
        //         snapshot.data!.contains(ConnectivityResult.none)) {
        //       return NoInternetPage();
        //     }
        //     return authentication.when(
        //         data: (userData) {
        //           printDebug('=====> uid : ${userData!.uid}');
        //           return HomePage();
        //         },
        //         error: (error, stackTrace) {
        //           return FailurePage();
        //         },
        //         loading: () => LoadingPage());
        //   },
        // ),
        );
  }
}

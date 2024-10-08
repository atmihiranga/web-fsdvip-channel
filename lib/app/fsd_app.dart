import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/view_models/firebase_anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/home/view/pages/home_page.dart';

class FsdApp extends ConsumerWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return MaterialApp(
      title: 'Forex Signals Daily',
      theme: AppTheme.darkTheme,
      home: isLoading
          ? const LoadingWidget(
              message: 'Authenticating',
            )
          : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

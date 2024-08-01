import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme.dart';
import 'package:project_3_forex_signals_daily/features/home/view/pages/home_page.dart';

class FsdApp extends StatelessWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSD App',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

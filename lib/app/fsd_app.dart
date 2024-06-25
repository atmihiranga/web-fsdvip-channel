import 'package:flutter/material.dart';
import 'package:project_3_forex_signals_daily/presentation/screens/homescreen.dart';

class FsdApp extends StatelessWidget {
  const FsdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

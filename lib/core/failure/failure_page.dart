import 'package:flutter/material.dart';

class FailurePage extends StatelessWidget {
  final String errorMessage = 'Something went wrong.';

  const FailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64),
            const SizedBox(height: 16),
            Text(errorMessage),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FailurePage extends StatelessWidget {
  final String errorMessage;

  const FailurePage({
    super.key,
    this.errorMessage = 'Something went wrong.',
  });

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

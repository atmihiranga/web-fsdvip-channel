import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64),
            const SizedBox(height: 16),
            const Text('No Internet Connection'),
            ElevatedButton(
              onPressed: () {
                // Trigger reconnection attempt
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoInternetPage extends ConsumerWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final internetConnection = ref.watch(connectivityViewModelProvider);
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
                // ref
                //     .read(connectivityViewModelProvider.notifier)
                //     .checkInternetConnectivity();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

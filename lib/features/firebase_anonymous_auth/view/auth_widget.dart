import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/view_models/firebase_anonymous_auth_viewmodel.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return Column(
            children: [
              Text('Signed in uid: ${user.uid}'),
              TextButton(
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).signOut();
                  },
                  child: const Text('Sign out')),
            ],
          );
        } else {
          return const Text('Not signed in');
        }
      },
      loading: () => const LoadingWidget(
        message: 'Authenticating',
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

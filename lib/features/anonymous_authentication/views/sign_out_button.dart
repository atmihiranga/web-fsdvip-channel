import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleUser = user?.providerData
            .any((provider) => provider.providerId == 'google.com') ??
        false;
    if (isGoogleUser) {
      return ListTile(
        title: const Text('Sign out'),
        trailing: Icon(Icons.logout),
        onTap: () {
          ref.read(authViewModelProvider.notifier).signOut();
          Navigator.pop(context);
        },
      );
    }
    return SizedBox.shrink();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';

class GoogleAuthWidget extends ConsumerWidget {
  const GoogleAuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleUser = user?.providerData
            .any((provider) => provider.providerId == 'google.com') ??
        false;

    if (!isGoogleUser) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: OutlinedButton.icon(
          onPressed: () =>
              ref.read(authViewModelProvider.notifier).linkWithGoogle(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            side: const BorderSide(color: Colors.grey),
            backgroundColor: Colors.white,
          ),
          icon: Icon(Icons.g_mobiledata),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user!.photoURL ?? ''),
          radius: 20,
          // Fallback icon if no photo URL
          child: user.photoURL == null ? const Icon(Icons.person) : null,
        ),
        title: Text(
          user.displayName ?? 'User',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          user.email ?? '',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
        ),
      ),
    );
  }
}

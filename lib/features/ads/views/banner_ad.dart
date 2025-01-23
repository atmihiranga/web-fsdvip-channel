import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_3_forex_signals_daily/features/ads/viewmodels/ads_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class BannerAdBottom extends ConsumerWidget {
  const BannerAdBottom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPremium = true;
    final userAccount = ref.watch(userAccountViewmodelProvider);
    userAccount.whenData((userAccount) {
      isPremium = userAccount.isPremium;
    });
    if (!isPremium) {
      final adState = ref.watch(adsViewModelProvider);
      return adState.when(
          data: (ad) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: SafeArea(
                child: SizedBox(
                  height: ad.size.height.toDouble(),
                  width: ad.size.width.toDouble(),
                  child: AdWidget(ad: ad),
                ),
              ),
            );
          },
          error: (error, stack) => SizedBox.shrink(),
          loading: () => SizedBox.shrink());
    }
    return SizedBox.shrink();
  }
}

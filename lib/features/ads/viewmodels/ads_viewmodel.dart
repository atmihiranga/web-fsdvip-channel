import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/ads/repositories/ads_repository.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'ads_viewmodel.g.dart';

@riverpod
class AdsViewModel extends _$AdsViewModel {
  late final AdsRepository _adsRepository;
  static const int _defaultClickThreshold = 5;
  int _clickCounter = 0;
  final int _clickThreshold;
  bool _isPremium = true;

  AdsViewModel({int clickThreshold = _defaultClickThreshold})
      : _clickThreshold = clickThreshold;

  @override
  AsyncValue<BannerAd> build() {
    final userAccount = ref.watch(userAccountViewmodelProvider);
    userAccount.whenData((userAccount) {
      if (!userAccount.isPremium) {
        _adsRepository = ref.watch(adsRepositoryProvider);
        _initializeMobileAds();
        _isPremium = false;
      } else {
        _isPremium = true;
      }
    });

    return AsyncValue.loading();
  }

  Future<void> trackUserInteraction() async {
    if (!_isPremium) {
      _clickCounter++;
      printDebug('=====> tracking taps : $_clickCounter');
      if (_clickCounter >= _clickThreshold) {
        final adShown = await _adsRepository.showInterstitialAd();
        if (adShown) {
          _clickCounter = 0; // Reset counter only if ad was actually shown
        }
      }
    } else {
      printDebug('=====> not tracking taps : premium user');
    }
  }

  void _initializeMobileAds() {
    _adsRepository.initializeMobileAds().then((onValue) {
      _initializeBannerAds();
    });
  }

  Future<void> _initializeBannerAds() async {
    try {
      final bannerAd = await _adsRepository.createBannerAd();
      await _adsRepository.loadBannerAd(bannerAd);
      state = AsyncValue.data(bannerAd);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

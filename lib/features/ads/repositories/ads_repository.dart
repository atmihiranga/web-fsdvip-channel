import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_3_forex_signals_daily/core/constants/constants.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'ads_repository.g.dart';

@riverpod
AdsRepository adsRepository(Ref ref) {
  return AdsRepository();
}

class AdsRepository {
  final MobileAds _mobileAds;
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitialAd = false;
  DateTime? _lastAdShownTime;
  static const int _minimumIntervalBetweenAds = 180; // 3 minutes in seconds

  AdsRepository({MobileAds? mobileAds})
      : _mobileAds = mobileAds ?? MobileAds.instance;

  Future<void> initializeMobileAds() async {
    try {
      await _mobileAds.initialize();
      // Pre-load first interstitial ad after initialization
      await loadInterstitialAd();
    } catch (e) {
      printDebug('=====> Error initializing ads: $e');
    }
  }

  bool get canShowAd {
    if (_lastAdShownTime == null) return true;

    final timeSinceLastAd =
        DateTime.now().difference(_lastAdShownTime!).inSeconds;
    return timeSinceLastAd >= _minimumIntervalBetweenAds;
  }

  Future<void> loadInterstitialAd() async {
    if (_interstitialAd == null && !_isLoadingInterstitialAd) {
      _isLoadingInterstitialAd = true;

      await InterstitialAd.load(
        adUnitId: AdUnitIds.getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (interstitialAd) {
            _interstitialAd = interstitialAd;
            _isLoadingInterstitialAd = false;
            _setupInterstitialAdCallbacks(interstitialAd);
          },
          onAdFailedToLoad: (error) {
            _isLoadingInterstitialAd = false;
            printDebug(
                '=====> Interstitial ad failed to load: ${error.message}');
            // Retry loading after a delay if failed
            Future.delayed(const Duration(minutes: 1), loadInterstitialAd);
          },
        ),
      );
    }
  }

  void _setupInterstitialAdCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _lastAdShownTime = DateTime.now();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        // Preload next ad
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        // Retry loading if show failed
        loadInterstitialAd();
      },
    );
  }

  Future<bool> showInterstitialAd() async {
    if (_interstitialAd == null) {
      printDebug('=====> Ad is not loaded');
      await loadInterstitialAd();
      return false;
    }

    if (!canShowAd) {
      printDebug('=====> Too soon to show another ad');
      return false;
    }

    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      printDebug('=====> Error showing interstitial ad: $e');
      return false;
    }
  }

  Future<BannerAd> createBannerAd() async {
    BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdUnitIds.getBannerAdUnitId(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          printDebug(
              '=====> ads repo > banner ad loaded : ${ad.responseInfo.toString()}');
        },
        onAdFailedToLoad: (ad, error) {
          printDebug(
              '===== ads repo > failed to load banner : ${error.message}');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    return bannerAd;
  }

  Future<void> loadBannerAd(BannerAd bannerAd) async {
    try {
      await bannerAd.load();
    } catch (e) {
      printDebug('=====> ads repo > error loading banner : $e');
    }
  }

  void disposeBannerAd(BannerAd? ad) {
    ad?.dispose();
  }
}

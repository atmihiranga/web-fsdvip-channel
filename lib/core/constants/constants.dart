import 'dart:io';

const Set<String> regularInAppProductIds = {
  'ffs_annual_subscription',
  'ffs_monthly_subscription'
};

class Links {
  static const String privacyPolicy =
      'https://klusterlabs.net/privacy-policy-forex-signals-daily/';

  static const String terms =
      'https://klusterlabs.net/terms-and-conditions-forex-signals-daily/';

  static const String telegramChannel = 'https://t.me/forexsignalsdailyapp';

  static const String contactEmail = 'klusterlabs@gmail.com';

  static const String csmIos =
      'https://apps.apple.com/app/currency-strength-meter/id6479727640';
  static const String csmAndroid =
      'https://play.google.com/store/apps/details?id=com.kluster.csi';
  static const String appStoreLink = '';
  static const String googlePlayLink = '';
}

class FirestoreCollections {
  static const String userDbCollection = 'userdb';
  static const String adminCollection = 'admin';
  static const String purchasesCollection = 'purchases';
}

class AdUnitIds {
  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7407448922396490/3516632271';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7407448922396490/9420168405';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7407448922396490/5951223924';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7407448922396490/4608731404';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

import 'package:firebase_admob/firebase_admob.dart';

const String appId = "ca-app-pub-9695790043722201~8654840320";

class Ads {
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: appId);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['game', 'overwatch'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

  static BannerAd _createBannerAd() {
    return BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: "ca-app-pub-9695790043722201/3765282201",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

  static void hideBannerAd() async {
    await _bannerAd.dispose();
    _bannerAd = null;
  }
}
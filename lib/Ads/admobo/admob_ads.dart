// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter/material.dart';
//
// class AdMobAds {
//   static BannerAd? _bannerAd;
//   static InterstitialAd? _interstitialAd;
//   static bool _isBannerAdReady = false;
//   static bool _isInterstitialAdReady = false;
//
//   static void initialize() {
//     print("AdMobAds: Initializing MobileAds");
//     MobileAds.instance.initialize();
//   }
//
//   static void loadBannerAd(String adUnitId) {
//     print("AdMobAds: Loading BannerAd with unit id $adUnitId");
//     _bannerAd = BannerAd(
//       adUnitId: adUnitId,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           print("AdMobAds: BannerAd loaded successfully");
//           _isBannerAdReady = true;
//         },
//         onAdFailedToLoad: (ad, err) {
//           print("AdMobAds: Failed to load BannerAd - $err");
//           _isBannerAdReady = false;
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }
//
//   static Widget getBannerAdWidget() {
//     if (_isBannerAdReady) {
//       print("AdMobAds: Displaying BannerAd");
//       return Container(
//         child: AdWidget(ad: _bannerAd!),
//         width: _bannerAd!.size.width.toDouble(),
//         height: _bannerAd!.size.height.toDouble(),
//         alignment: Alignment.center,
//       );
//     } else {
//       return SizedBox.shrink();
//     }
//   }
//
//   static void loadInterstitialAd(String adUnitId) {
//     print("AdMobAds: Loading InterstitialAd with unit id $adUnitId");
//     InterstitialAd.load(
//       adUnitId: adUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           print("AdMobAds: InterstitialAd loaded successfully");
//           _interstitialAd = ad;
//           _isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (err) {
//           print("AdMobAds: Failed to load InterstitialAd - $err");
//           _isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }
//
//   static void showInterstitialAd() {
//     if (_isInterstitialAdReady && _interstitialAd != null) {
//       print("AdMobAds: Showing InterstitialAd");
//       _interstitialAd!.show();
//       _interstitialAd = null;
//       _isInterstitialAdReady = false;
//     } else {
//       print("AdMobAds: InterstitialAd not ready");
//     }
//   }
// }

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  static String get bannerUnit => 'ca-app-pub-3940256099942544/9214589741';
  late RewardedAd _rewardedAd;
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;

  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd getBannerAd() {
    BannerAd bAd = new BannerAd(
        size: AdSize.banner,
        adUnitId: bannerUnit,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  // create interstitial ads
  void createInterad() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        num_of_attempt_load = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        num_of_attempt_load + 1;
        _interstitialAd = null;

        if (num_of_attempt_load <= 2) {
          createInterad();
        }
      }),
    );
  }

  // show interstitial ads to user
  void showInterad() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      createInterad();
    });

    _interstitialAd!.show();

    _interstitialAd = null;
  }

  void createRewardAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            this._rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  void showRewardAd() {
    _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      print("Adds Reward is ${rewardItem.amount}");
    });
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
  }

}

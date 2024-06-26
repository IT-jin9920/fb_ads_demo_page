import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdDisplay {
  bool displayRealAd = true;

  final adUnitIdInterstitial = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';
  final adUnitIdRewarded = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';
  final adUnitIdRewardedInterstitial = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-3940256099942544/6978759866';
  String adUnitIdOpenApp = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/925739592'
      : 'ca-app-pub-3940256099942544/5662855259';

  void loadInterstitial() {
    InterstitialAd.load(
        adUnitId: adUnitIdInterstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            showInterstitial(ad);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void showInterstitial(InterstitialAd ad) {
    ad.show();
  }

  void loadRewarded() {
    RewardedAd.load(
        adUnitId: adUnitIdRewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            showRewarded(ad);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void showRewarded(RewardedAd ad) {
    ad.show(onUserEarnedReward: (ad, rewardItem) {
      // Reward the user for watching an ad.
    });
  }

  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: adUnitIdRewardedInterstitial,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            showRewardedInterstitialAd(ad);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  void showRewardedInterstitialAd(RewardedInterstitialAd ad) {
    ad.show(onUserEarnedReward: (ad, rewardItem) {
      // Reward the user for watching an ad.
    });
  }

  void loadOpenAppAd(BuildContext context) {
    AppOpenAd.load(
      adUnitId: adUnitIdOpenApp,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          showOpenAppAd(ad);
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Display flushbar
          Flushbar(
            message: 'Failed to load App Open Ad',
            duration: Duration(seconds: 3),
          )..show(context);
        },
      ),
    );
  }

  void showOpenAppAd(AppOpenAd ad) {
    ad.show();
  }


}

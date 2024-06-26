import 'dart:io' show Platform;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Ads/admobo/AdDsiplay.dart';
import 'Ads/admobo/admob_ads.dart';


class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdShowing = false;
  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;
  int _numRewardedInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  final Duration maxCacheDuration = Duration(hours: 4);

  DateTime? _appOpenLoadTime;

  BannerAd? banner_ad;

  bool _isLoaded = false;

  final String appOpenAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9257395921' // Replace with your Android App Open Ad Unit ID
      : 'ca-app-pub-6920971193655721/1400494697'; // Replace with your iOS App Open Ad Unit ID

  @override
  void initState() {
    super.initState();
    loadAdappOpenAd();
    _createInterstitialAd();
    _createRewardedAd();
    _createRewardedInterstitialAd();
    //_loadInterstitialAd();
    //_loadRewardedVideoAd();
  }

  /// Load an AppOpenAd.
  void loadAdappOpenAd() {
    AppOpenAd.loadWithAdManagerAdRequest(
      adUnitId: appOpenAdUnitId,
      // adUnitId: appOpenAdUnitId,
      // orientation: AppOpenAd.orientationPortrait,
      adManagerAdRequest: AdManagerAdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  void _showAppOpenAd() {
    if (_appOpenAd == null || _isAppOpenAdShowing) {
      print('Warning: App Open Ad is null or already showing');
      Flushbar(
        message: 'Failed to load App Open Ad',
        duration: Duration(seconds: 3),
      )..show(context);
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        print('App Open Ad dismissed');
        _appOpenAd = null;
        _isAppOpenAdShowing = false;
        loadAdappOpenAd(); // Preload the next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('App Open Ad failed to show: $error');
        _appOpenAd = null;
        _isAppOpenAdShowing = false;
        loadAdappOpenAd(); // Preload the next ad
      },
    );
    _appOpenAd!.show();
    _isAppOpenAdShowing = true;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-6920971193655721/6461249684',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Interstitial Ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad failed to load: $error');
          _numInterstitialLoadAttempts++;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Interstitial Ad dismissed');
        ad.dispose();
        _createInterstitialAd(); // Preload the next ad
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Interstitial Ad failed to show: $error');
        ad.dispose();
        _createInterstitialAd(); // Preload the next ad
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-7319269804560504/6645907620'
          : 'ca-app-pub-7319269804560504/2207757133',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded Ad loaded');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded Ad failed to load: $error');
          _numRewardedLoadAttempts++;
          _rewardedAd = null;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded ad before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Rewarded Ad dismissed');
        ad.dispose();
        _createRewardedAd(); // Preload the next ad
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Rewarded Ad failed to show: $error');
        ad.dispose();
        _createRewardedAd(); // Preload the next ad
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print(
            'Rewarded Ad: User earned reward of ${reward.amount} ${reward.type}');
      },
    );
    _rewardedAd = null;
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5354046379'
          : 'ca-app-pub-3940256099942544/6978759866',
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          print('Rewarded Interstitial Ad loaded');
          _rewardedInterstitialAd = ad;
          _numRewardedInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded Interstitial Ad failed to load: $error');
          _numRewardedInterstitialLoadAttempts++;
          _rewardedInterstitialAd = null;
          if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedInterstitialAd();
          }
        },
      ),
    );
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial ad before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            print('Rewarded Interstitial Ad dismissed');
            ad.dispose();
            _createRewardedInterstitialAd(); // Preload the next ad
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            print('Rewarded Interstitial Ad failed to show: $error');
            ad.dispose();
            _createRewardedInterstitialAd(); // Preload the next ad
          },
        );
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print(
            'Rewarded Interstitial Ad: User earned reward of ${reward.amount} ${reward.type}');
      },
    );
    _rewardedInterstitialAd = null;
  }

  // void _loadInterstitialAd() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     // placementId: "YOUR_PLACEMENT_ID",
  //     placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
  //     listener: (result, value) {
  //       print(">> FAN > Interstitial Ad: $result --> $value");
  //       if (result == InterstitialAdResult.LOADED)
  //         _isInterstitialAdLoaded = true;
  //
  //       if (result == InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         _isInterstitialAdLoaded = false;
  //         _loadInterstitialAd();
  //       }
  //     },
  //   );
  // }
  //
  // void _loadRewardedVideoAd() {
  //   FacebookRewardedVideoAd.loadRewardedVideoAd(
  //     placementId: "YOUR_PLACEMENT_ID",
  //     listener: (result, value) {
  //       print("Rewarded Ad: $result --> $value");
  //       if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
  //       if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
  //
  //         /// Once a Rewarded Ad has been closed and becomes invalidated,
  //         /// load a fresh Ad by calling this function.
  //         if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
  //             (value == true || value["invalidated"] == true)) {
  //           _isRewardedAdLoaded = false;
  //           _loadRewardedVideoAd();
  //         }
  //     },
  //   );
  // }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("App Open Ad button pressed");
                  _showAppOpenAd();
                  //loadAdappOpenAd();
                },
                child: Text('Show App Open Ad'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  print("Interstitial Ad button pressed");
                  _showInterstitialAd();
                },
                child: Text('Show Interstitial Ad'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  print("Rewarded Interstitial Ad button pressed");
                  _showRewardedInterstitialAd();
                },
                child: Text('Show Rewarded Interstitial Ad'),
              ),
              SizedBox(
                height: 20,
              ),
              !_isLoaded
                  ? Container()
                  : Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: banner_ad!.size.width.toDouble(),
                    height: banner_ad!.size.height.toDouble(),
                    child: AdWidget(ad: banner_ad!),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    DisplayBannerAd();
                  },
                  child: Text("Show Banner Ad")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    AdDisplay().loadInterstitial();
                  },
                  child: Text("Display an interstitial ad")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    AdDisplay().loadRewarded();
                  },
                  child: Text("Display an rewarded ad")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    AdDisplay().loadRewardedInterstitialAd();
                  },
                  child: Text("Display Rewarded Interstitial ad")),
              SizedBox(
                height: 20,
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          child: AdWidget(
            ad: AdmobHelper.getBannerAd()..load(),
            key: UniqueKey(),
          ),
          height: 50),
    );
  }

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final adUnitIdLive = Platform.isAndroid
      ? 'ca-app-pub-4816405694010595/9963563115'
      : 'ca-app-pub-3940256099942544/2934735716';

  DisplayBannerAd() {
    banner_ad = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
          // setState(() {
          //   _isLoaded = true;
          // });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
    setState(() {});
  }
}

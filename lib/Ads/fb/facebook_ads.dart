// import 'dart:math';
//
// import 'package:easy_audience_network/easy_audience_network.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:flutter/material.dart';
//
// class FacebookAds {
//   static void initialize() {
//     FacebookAudienceNetwork.init();
//   }
//
//   static Widget getBannerAd(String placementId) {
//     return FacebookBannerAd(
//       placementId: placementId,
//      // bannerSize: BannerSize.STANDARD,
//       listener: (result, value) {
//         // Handle listener
//       },
//     );
//   }
//
//   static void showInterstitialAd(String placementId) {
//     FacebookInterstitialAd.loadInterstitialAd(
//       placementId: placementId,
//       listener: (result, value) {
//         if (result == InterstitialAdResult.LOADED) {
//           FacebookInterstitialAd.showInterstitialAd(delay: 5000);
//          // FacebookInterstitialAd.showInterstitialAd();
//         }
//       },
//     );
//   }
//
//
//   static void init(){
//     EasyAudienceNetwork.init(
//      // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
//       testMode: true, // optional
//       iOSAdvertiserTrackingEnabled: true, //default false
//     );
//   }
//
//   static void interstitialAd(){
//
//     final interstitialAd = InterstitialAd(InterstitialAd.testPlacementId);
//     interstitialAd.listener = InterstitialAdListener(
//       onLoaded: () {
//         interstitialAd.show();
//         print('Interstitial load');
//       },
//       onDismissed: () {
//         interstitialAd.destroy();
//         print('Interstitial dismissed');
//       },
//       onError: (i,e){
//         print('Interstitial ERROR : $e');
//       }
//     );
//     interstitialAd.load();
//
//   }
//
// }

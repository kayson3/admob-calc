import 'dart:io';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

class Ads extends StatefulWidget {
  @override
  _AdsState createState() => new _AdsState();
}

class _AdsState extends State<Ads> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobBanner bannerAd;
  AdmobBanner bannerAd3;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();

    bannerSize = AdmobBannerSize.BANNER;

    bannerAd = AdmobBanner(
        adUnitId: getBannerAdUnitId(),
        adSize: bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        });
    bannerAd3 = AdmobBanner(
        adUnitId: "ca-app-pub-2384873801315869/9081324079",
        adSize: bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        });
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    interstitialAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load.');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  // interstitialAd
  void fullScreenAd() async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
      showSnackBar('Interstitial ad is still loading...');
      interstitialAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Admob'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: bannerAd,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: AdmobBanner(
                  adUnitId: "ca-app-pub-2384873801315869/9272895763",
                  adSize: bannerSize,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  }),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: bannerAd3,
            ),
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      FlatButton(
                          color: Colors.blue,
                          onPressed: () => fullScreenAd(),
                          child: Text('interstitial1')),
                      SizedBox(width: 10),
                      FlatButton(
                          color: Colors.blue,
                          onPressed: () => fullScreenAd(),
                          child: Text('interstitial2'))
                    ],
                  ),
                  SizedBox(height: 5),
                  Text('click any of the buttons')
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: bannerAd3,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: AdmobBanner(
                  adUnitId: "ca-app-pub-2384873801315869/9272895763",
                  adSize: bannerSize,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  }),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: bannerAd,
            ),
          ],
        ),
      ),
    );

    @override
    void dispose() {
      interstitialAd.dispose();
      super.dispose();
    }
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2384873801315869/9820331302';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2384873801315869/8151385784';
  }
  return null;
}

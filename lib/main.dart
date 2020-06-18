import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safer/pages/mainTabs.dart';
import 'package:safer/pages/noConnectivity.dart';
import 'package:safer/pages/unlogged.dart';
import 'package:safer/routes.dart';
import 'package:safer/colors/colors.dart';

void main() => runApp(Safer());

class Safer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SaferState();
  }
}

class _SaferState extends State<Safer> {
  void checkConnecivity() async {
    await getRootPage().then((Widget page) {
      setState(() {
        _rootPage = page;
      });
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await getRootPage().then((Widget page) {
        setState(() {
          _rootPage = page;
        });
      });
    } else {
      setState(() {
        _rootPage = NoConnectivityPage();
      });
    }
  }

  Image image1;
  Image image2;
  Image image3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
  }

  Widget _rootPage;

  Future<Widget> getRootPage() async =>
      FirebaseAuth.instance.currentUser().then((user) {
        if (user == null || user.isAnonymous) {
          return UnLoggedPage();
        } else {
          return MainTabsPage();
        }
      });

  @override
  void initState() {
    image1 = Image.asset(
      'assets/unlogged-1.png',
      width: 50,
    );
    image2 = Image.asset(
      'assets/unlogged-2.png',
      width: 50,
    );
    image3 = Image.asset(
      'assets/unlogged-3.png',
      width: 50,
    );
    super.initState();
    _rootPage = SplashScreen();
    Timer(Duration(seconds: 5), () {
      checkConnecivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safer',
      home: _rootPage,
      routes: buildAppRoutes(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/main-circular-logo.png',
                width: 220,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(SaferColors().getSplashGray())),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
          ],
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';

import 'package:safer/pages/login.dart';
import 'package:safer/pages/mainTabs.dart';
import 'package:safer/pages/markerDetails.dart';
import 'package:safer/pages/markerShow.dart';
import 'package:safer/pages/noConnectivity.dart';
import 'package:safer/pages/register.dart';
import 'package:safer/pages/unlogged.dart';

import 'main.dart';

Map<String, WidgetBuilder> buildAppRoutes() {
  return {
    '/main': (BuildContext context) => Safer(),
    '/noConnectivty': (BuildContext context) => NoConnectivityPage(),
    '/unlogged': (BuildContext context) => UnLoggedPage(),
    '/login': (BuildContext context) => LoginPage(),
    '/register': (BuildContext context) => RegisterPage(),
    '/maintabs': (BuildContext context) => MainTabsPage(),
    '/markerDetails': (BuildContext context) => MarkerDetails(),
    '/markerShow': (BuildContext context) => MarkerShowPage()
  };
}

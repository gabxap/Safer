import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safer/colors/colors.dart';
import 'package:safer/pages/accountSettings.dart';
import 'package:safer/pages/crimeFeed.dart';
import 'package:safer/pages/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainTabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTabsPageState();
  }
}

class _MainTabsPageState extends State<MainTabsPage> {
  void setupPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    await prefs.setString('uid', uid);
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((datasnapshot) async {
      await prefs.setString('username', datasnapshot.data['nombre']);
    });
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('locations')
        .where('user', isEqualTo: prefs.getString('username'))
        .getDocuments();
    var list = querySnapshot.documents;
    await prefs.setInt('noi', list.length);
  }

  @override
  void initState() {
    setupPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Safer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontFamily: 'BreeSerif'),
              ),
            ],
          ),
          backgroundColor: Color(SaferColors().getSaferGreen()),
          centerTitle: true,
        ),
        body: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                CrimeFeedPage(),
                MapPage(),
                AccountSettingsPage()
              ],
            ),
            bottomNavigationBar: PreferredSize(
              preferredSize: Size(60.0, 60.0),
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontSize: 10.0),
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.list),
                  ),
                  Tab(
                    icon: Icon(Icons.map),
                  ),
                  Tab(
                    icon: Icon(Icons.supervisor_account),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

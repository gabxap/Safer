import 'package:flutter/material.dart';
import 'package:safer/colors/colors.dart';

class NoConnectivityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoConnectivityPageState();
  }
}

class _NoConnectivityPageState extends State<NoConnectivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(SaferColors().getSaferGreen()),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi,
              size: 200,
              color: Color(SaferColors().getSaferGreen()),
            ),
            Text('Conectate a internet para usar Safer.',
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        )));
  }
}

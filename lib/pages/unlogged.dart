import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safer/colors/colors.dart';

class UnLoggedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UnLoggedPageState();
  }
}

class _UnLoggedPageState extends State<UnLoggedPage> {
  Image image1;
  Image image2;
  Image image3;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // here the desired height
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Color(SaferColors().getSaferGreen()),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Porque una ciudad unida contra el crimen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'es una ciudad segura',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          createItem(
              'Prevé antes y después de \nsalir de casa ', false, 1, image1),
          createItem('Registra los incidentes de\ntu ciudad ', true, 2, image2),
          createItem(
              'Protégete a ti y a los que \nmás quieres ', true, 3, image3),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          customizedButton('Iniciar sesión',
              () => {Navigator.of(context).pushNamed('/login')}),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          customizedButton('Regístrate',
              () => {Navigator.of(context).pushNamed('/register')}),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('Hecho en Lima, Perú 🇵🇪'),
          )
        ],
      )),
    );
  }
}

Widget createItem(String textitem, bool line, int order, Image img) {
  Widget setDivisionLine(bool b) {
    if (b) {
      return (Padding(
        padding: EdgeInsets.only(right: 60, left: 60),
        child: Divider(
          color: Colors.black,
        ),
      ));
    } else {
      return Padding(
        padding: EdgeInsets.all(0),
      );
    }
  }

  return (Column(
    children: <Widget>[
      setDivisionLine(line),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          img,
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
            child: Text(
              textitem,
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      )
    ],
  ));
}

Widget customizedButton(String text, VoidCallback action) {
  return (Padding(
    padding: EdgeInsets.only(right: 30, left: 30),
    child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Color(SaferColors().getSaferGreen()),
          textColor: Colors.white,
          child: Text(text),
          onPressed: action,
        )),
  ));
}

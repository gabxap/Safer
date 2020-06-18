import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safer/colors/colors.dart';
import 'package:share/share.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountSettingsPageState();
  }
}

class _AccountSettingsPageState extends State<AccountSettingsPage>
    with AutomaticKeepAliveClientMixin<AccountSettingsPage> {
  String _username = 'Cargando...';
  String _uid;
  var _counterReports = 'Cargando...';
  @override
  void initState() {
    void _reportsCounter() async {
      var querySnapshot = await Firestore.instance
          .collection('locations')
          .where('uid', isEqualTo: _uid)
          .getDocuments();
      var list = querySnapshot.documents;
      setState(() {
        _counterReports = list.length.toString();
      });
    }

    inputData().then((value) async {
      var document = Firestore.instance.collection('users').document(value);
      await document.get().then((datasnapshot) {
        setState(() {
          _uid = value.toString();
          _username = datasnapshot.data['nombre'];
        });
        _reportsCounter();
      });
    });
    super.initState();
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.of(context).pushReplacementNamed('/unlogged');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 0, left: 0, top: 20),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
              child: Text(
                _username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.assistant_photo,
                color: Colors.red,
              ),
              title: Text('Incidentes reportados: $_counterReports'),
            ),
            ListTile(
              leading: Icon(
                Icons.email,
                color: Colors.indigo,
              ),
              title: Text('Cambiar correo'),
              onTap: () => onAlertChangeEmail(context),
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.orange,
              ),
              title: Text('Cambiar contraseña'),
              onTap: () => onAlertChangePassword(context),
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.pink,
              ),
              title: Text('Compartir Safer'),
              onTap: () async {
                final RenderBox box = context.findRenderObject();
                await Share.share('https://www.instagram.com/safer.app/?hl=es',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Colors.green,
              ),
              title: Text('Acerca de Safer'),
              onTap: () => aboutSafer(context),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _logOut,
            )
          ],
        )
        //]
        //),

        );
  }

  Future<String> inputData() async {
    final user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid.toString();
    return uid;
  }

  void onAlertChangeEmail(context) {
    final _formKey = GlobalKey<FormState>();

    //final form = _formKey.currentState;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _newEmailController = TextEditingController();

    Alert(
        buttons: [],
        context: context,
        title: 'Cambiar correo',
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Correo'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Contraseña',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _newEmailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail_outline),
                      labelText: 'Nuevo correo',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Color(SaferColors().getSaferGreen()),
                        textColor: Colors.white,
                        child: Text('Siguiente'),
                        onPressed: () async {
                          String _email =
                              _emailController.text.toString().trim();
                          String _pass =
                              _passwordController.text.toString().trim();
                          String _newEmail =
                              _newEmailController.text.toString().trim();
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email, password: _pass)
                              .then((userCredential) {
                            userCredential.updateEmail(_newEmail);
                            Navigator.pop(context);
                            _logOut();
                          });
                        },
                      ))
                ],
              ),
            )
          ],
        )).show();
  }

  void onAlertChangePassword(context) {
    final _formKey = GlobalKey<FormState>();

    //final form = _formKey.currentState;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();

    Alert(
        buttons: [],
        context: context,
        title: 'Cambiar contraseña',
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Correo'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Contraseña',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Nueva contraseña',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Color(SaferColors().getSaferGreen()),
                        textColor: Colors.white,
                        child: Text('Siguiente'),
                        onPressed: () async {
                          String _email =
                              _emailController.text.toString().trim();
                          String _pass =
                              _passwordController.text.toString().trim();
                          String _newPassword =
                              _newPasswordController.text.toString();
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email, password: _pass)
                              .then((userCredential) {
                            userCredential.updatePassword(_newPassword);
                            Navigator.pop(context);
                            _logOut();
                          });
                        },
                      ))
                ],
              ),
            )
          ],
        )).show();
  }

  void aboutSafer(context) {
    Alert(
        buttons: [],
        context: context,
        title: 'Acerca de',
        content: Column(
          children: <Widget>[
            Text(
              'Safer',
              style: TextStyle(
                  color: Color(SaferColors().getSaferGreen()),
                  fontSize: 35.0,
                  fontFamily: 'BreeSerif'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              'Safer es una plataforma de colaboración comunitaria cuya finalidad es hacer una sociedad mucho más segura y justa para todos. Safer es un proyecto independiente de Gabriel Armas Aranibar.',
              textAlign: TextAlign.justify,
            )
          ],
        )).show();
  }

  @override
  bool get wantKeepAlive => true;
}

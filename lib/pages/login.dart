import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safer/behaviors/hiddenScrollBehavior.dart';
import 'package:safer/colors/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  final TextEditingController _emailCheck = TextEditingController();

  bool _isLoggingIn = false;
  void login() async {
    if (_isLoggingIn) return;
    setState(() {
      _isLoggingIn = true;
    });
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Espera...'),
      ),
    );

    final form = _formKey.currentState;
    if (form.validate() == false) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
        _isLoggingIn = false;
      });
      return;
    }
    form.save();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      await Navigator.of(context).pushNamedAndRemoveUntil(
        '/maintabs',
        ModalRoute.withName('/main'),
      );
    } catch (e) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'cerrar',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  void forgotPassword(String email) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Se envió un correo para restablecer tu contraseña'),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: 'cerrar',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Iniciar sesión'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(SaferColors().getSaferGreen()),
        ),
        body: ScrollConfiguration(
            behavior: HiddenScrollBehavior(),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Image.asset(
                              'assets/main-circular-logo.png',
                              width: 100,
                            ),
                            /*Text(
                'Safer'
                ,style: TextStyle(
                  color: Color(SaferColors().getSplashGray()), 
                  fontSize: 50.0,
                  fontFamily: 'BreeSerif'
                  ),
              ),
                */
                          ]),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: Column(children: <Widget>[
                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailCheck,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                hintText: 'Correo'),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Ingresa un correo válido';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                hintText: 'Contraseña'),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Ingresa una contraseña válida';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          customizedButton('Siguiente', () => login()),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlatButton(
                                child: Text('¿Olvidaste tu contraseña?'),
                                onPressed: () {
                                  _email = _emailCheck.text;
                                  if (_email != null && _email != '') {
                                    forgotPassword(_email);
                                  } else {
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Ingresa un correo'),
                                        duration: Duration(seconds: 10),
                                        action: SnackBarAction(
                                          label: 'cerrar',
                                          onPressed: () {
                                            _scaffoldKey.currentState
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                textColor: Colors.redAccent,
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget customizedButton(String text, VoidCallback action) {
    return (Padding(
      padding: EdgeInsets.only(right: 0, left: 0),
      child: SizedBox(
          width: double.infinity,
          height: 50,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Color(SaferColors().getSaferGreen()),
            textColor: Colors.white,
            child: Text(text),
            onPressed: action,
          )),
    ));
  }
}

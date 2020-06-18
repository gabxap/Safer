import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:safer/behaviors/hiddenScrollBehavior.dart';
import 'package:safer/colors/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Regístrate'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(SaferColors().getSaferGreen()),
        ),
        body: RegisterWidget());
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterWidgetState();
  }
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _fullName;
  String _email;
  String _password;
  String _passwordConfirm;
  bool _isRegistering = false;
  bool _passwordDifferent = false;

  void register() async {
    if (_isRegistering) return;
    setState(() {
      _isRegistering = true;
    });
    setState(() {});
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Espera...'),
    ));

    final form = _formKey.currentState;
    if (form.validate() == false) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
        _isRegistering = false;
      });
      return;
    }
    form.save();

    if (_password != _passwordConfirm) {
      _passwordDifferent = true;
    }

    if (_passwordDifferent == true) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Confirma correctamente tu contraseña'),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: 'cerrar',
          onPressed: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ));
      setState(() {
        _passwordDifferent = false;
        _isRegistering = false;
      });
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((currentUser) => Firestore.instance
                    .collection('users')
                    .document(currentUser.uid)
                    .setData({
                  'uid': currentUser.uid,
                  'nombre': _fullName,
                  'email': _email
                }));
        await Navigator.of(context)
            .pushNamedAndRemoveUntil('/maintabs', ModalRoute.withName('/main'));
      } catch (e) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e.message),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'cerrar',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        ));
      } finally {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ScrollConfiguration(
        behavior: HiddenScrollBehavior(),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          Image.asset(
                            'assets/main-circular-logo.png',
                            width: 100,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Regístrate gratís',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ]),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        hintText: 'Nombre completo',
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Ingresa un nombre';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (val) {
                        setState(() {
                          _fullName = val;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
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
                          _email = val.trim();
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
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          hintText: 'Confirma tu contraseña'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Ingresa una confirmación de la contraseña';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (val) {
                        setState(() {
                          _passwordConfirm = val;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: customizedButton('Registrarme', () => register()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(14),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
            onPressed: () {
              action();
            })),
  ));
}

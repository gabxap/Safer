import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safer/behaviors/hiddenScrollBehavior.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safer/functionalities/saferDay.dart';

class MarkerAddPage extends StatefulWidget {
  final LatLng geopoint;
  MarkerAddPage(this.geopoint);

  @override
  State<StatefulWidget> createState() {
    return _MarkerAddPageState(geopoint);
  }
}

class _MarkerAddPageState extends State<MarkerAddPage> {
  final databaseReference = Firestore.instance;

  var today = DateTime.now();
  LatLng geopoint;
  _MarkerAddPageState(this.geopoint);

  Firestore firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _incidentValue = 'Asalto callejero';
  bool isSwitched = false;
  TextEditingController _detallecontroller = TextEditingController();
  String _detalle;
  String _user;
  String _userId;
  String _date = ' No especificada';
  String _time = ' No especificada';
  String _hour, _minute, _second;
  static String _month, _day, _year;
  String _commentsDoc;
  int _saferDay;
  File galleryFile;

  @override
  void initState() {
    inputData().then((value) async {
      _userId = value.toString();
      var document =
          await Firestore.instance.collection('users').document(value);
      await document.get().then((datasnapshot) {
        _user = datasnapshot.data['nombre'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Nuevo incidente'),
      ),
      body: ScrollConfiguration(
          behavior: HiddenScrollBehavior(),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(
                                'Categoría: $_incidentValue',
                              ),
                              onPressed: () {
                                selectIncidentDialog();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          TextFormField(
                            controller: _detallecontroller,
                            onSaved: (val) {
                              setState(() {
                                _detalle = val;
                              });
                            },
                            maxLines: 12,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                              ),
                              hintText: '¿Qué fue lo que pasó?',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2019, 8, 14),
                                      maxTime: DateTime(
                                          today.year, today.month, today.day),
                                      onConfirm: (date) {
                                    setState(() {
                                      _day = date.day.toString();
                                      _month = date.month.toString();
                                      _year = date.year.toString();
                                      _date =
                                          '${date.day.toString()}/${date.month.toString()}/${date.year.toString()} ';
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.es);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range),
                                    Text(_date)
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  DatePicker.showTimePicker(context,
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    setState(() {
                                      //Hour
                                      _hour = time.hour.toString();
                                      _minute = time.minute.toString();
                                      _second = time.second.toString();
                                      if (int.parse(_hour) < 10) {
                                        _hour = '0' + time.hour.toString();
                                      }
                                      if (int.parse(_minute) < 10) {
                                        _minute = '0' + time.minute.toString();
                                      }
                                      if (int.parse(_second) < 10) {
                                        _second = '0' + time.second.toString();
                                      }
                                      _time = ' $_hour:$_minute';
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.es);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time),
                                    Text(_time)
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Reportar como anónimo'),
                              Checkbox(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ))))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.send),
        tooltip: 'Reportar',
        onPressed: comprobar,
      ),
    );
  }

  void selectIncidentDialog() {
    FocusScope.of(context).unfocus();
    Widget customizedOption(String text) {
      return SimpleDialogOption(
        child: Text(text),
        onPressed: () {
          setState(() {
            _incidentValue = text;
          });
          Navigator.of(context).pop();
        },
      );
    }

    SimpleDialog dialog = SimpleDialog(
      title: const Text('Selecciona una categoría'),
      children: <Widget>[
        customizedOption('Asalto callejero'),
        customizedOption('Actividad sospechosa'),
        customizedOption('Acoso'),
        customizedOption('Disturbio'),
        customizedOption('Robo de vivienda'),
        customizedOption('Venta de nárcoticos'),
        customizedOption('Mascota perdida'),
        customizedOption('Otro'),
        customizedOption('Pruba')
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  void comprobar() async {
    if (!isSwitched) {
      await inputData().then((value) async {
        var document =
            await Firestore.instance.collection('users').document(value);
        await document.get().then((datasnapshot) {
          setState(() {
            _user = datasnapshot.data['nombre'];
          });
        });
      });
    } else {
      setState(() {
        _user = 'Anónimo';
      });
      setState(() {
        _userId = 'Anónimo';
      });
    }

    if (_detallecontroller.text == '' || _detallecontroller.text.length < 25) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Detallanos exactamente que fue lo que pasó.'),
      ));
    } else if (_time == ' No especificada' || _date == ' No especificada') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Detallanos la fecha y hora del acontecimiento aproximada'),
      ));
    } else {
      _formKey.currentState.save();
      _saferDay = SaferDay(
              DateTime.utc(2019, DateTime.august, 14),
              DateTime.utc(
                  int.parse(_year), int.parse(_month), int.parse(_day)))
          .getSaferDay();
      await addGeoPoint();
      Navigator.of(context).pop();
    }
  }

  Future<DocumentReference> addCommentsection() async {
    return firestore
        .collection('comments')
        .add({'activated': false, 'n_comments': 0});
  }

  void addCommentId() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('comments').getDocuments();
    var list = querySnapshot.documents;
    list.forEach((document) {
      bool conditional = document.data['activated'];
      if (conditional != null) {
        if (!conditional) {
          _commentsDoc = document.documentID;
        }
      }
    });
    try {
      await databaseReference
          .collection('comments')
          .document(_commentsDoc)
          .updateData({'activated': true});
    } catch (e) {
      print(e.toString());
    }
  }

  void addGeoPoint() {
    addCommentsection();
    addCommentId();
    if (isSwitched) {
      setState(() {
        _user = 'Anónimo';
      });
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      return firestore.collection('locations').add({
        'latitude': geopoint.latitude,
        'longitude': geopoint.longitude,
        'name': _incidentValue,
        'descripcion': _detalle,
        'fecha': _date,
        'hora': _time,
        'saferDay': _saferDay,
        'user': _user,
        'uid': _userId,
        'comments_Id': _commentsDoc,
      });
    });
  }
}

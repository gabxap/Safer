import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safer/arguements/MarkerDetailsA.dart';
import 'package:safer/functionalities/saferDay.dart';
import 'package:safer/pages/markerAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safer/functionalities/customPermissions.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin<MapPage> {
  @override
  bool get wantKeepAlive => true;

  //Dates Stuff
  static var today = DateTime.now();
  final int _todaySaferDay = SaferDay(DateTime.utc(2019, DateTime.august, 14),
          DateTime.utc(today.year, today.month, today.day))
      .getSaferDay();

  //Markers
  final Set<Marker> _markers = {};

  //Map Setup
  GoogleMapController mapController;
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(-12.0244094, -76.9874568), zoom: 10);
  LatLng _lastMapPosition = LatLng(-12.078227, -77.055827);
  Location location = Location();

  // I N C I D E N T E
  Icon _iconRecordBtn = Icon(
    Icons.add_location,
    color: Colors.white,
  );
  Text _phraseRecordBtn = Text(
    '  I N C I D E N T E  ',
    style: TextStyle(color: Colors.white),
  );
  VoidCallback _indicenteBtn;
  bool _markerShow = false;
  BitmapDescriptor pointer = BitmapDescriptor.defaultMarker;

  // F I L T R O S
  bool _filterMenu = false;
  bool _fitlterButton = true;
  int _currtime = 1;

  @override
  void initState() {
    Timer.periodic(
        Duration(seconds: 1), (Timer t) => updateMarkers(_markerShow));
    _indicenteBtn = () => {markerAddPreview()};
    requestPermission('location');
    location.onLocationChanged().listen((location) async {
      _initialPosition = CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 10);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            markers: _markers,
            onCameraMove: onCameraMove,
          ),
          Positioned(
            top: 5,
            right: 56,
            left: 53,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_iconRecordBtn, _phraseRecordBtn],
              ),
              color: Colors.red,
              onPressed: _indicenteBtn,
            ),
          ),
          Visibility(
            visible: _markerShow,
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 50,
                      color: Colors.red,
                    ),
                    Text(
                      'Arrastra el mapa',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    )
                  ],
                )),
          ),
          Visibility(
            visible: _markerShow,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: FloatingActionButton(
                      tooltip: 'Cancelar',
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 60,
                      ),
                      onPressed: normalPreview,
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _fitlterButton,
            child: Positioned(
              top: 50,
              right: 56,
              left: 53,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                    Text('  FILTRAR  RESULTADOS ',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    _filterMenu = true;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: _filterMenu,
            child: Wrap(children: <Widget>[
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 20, top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Filtrar resultados',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: _currtime,
                          onChanged: handleFilterValueChange,
                        ),
                        Text(
                          '+30',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _currtime,
                          onChanged: handleFilterValueChange,
                        ),
                        Text(
                          '7 días',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Radio(
                          value: 2,
                          groupValue: _currtime,
                          onChanged: handleFilterValueChange,
                        ),
                        Text(
                          'Hoy',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    FlatButton(
                      child: Text('cerrar'),
                      onPressed: () {
                        setState(() {
                          _filterMenu = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  /*  FUNCIONES */

  //Google Maps
  void onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  //Filters
  void handleFilterValueChange(int value) {
    setState(() {
      _currtime = value;
      _markers.clear();
    });
  }

//Initial-Normal Preview
  void normalPreview() {
    setState(() {
      _iconRecordBtn = Icon(
        Icons.add_location,
        color: Colors.white,
      );
      _phraseRecordBtn = Text(
        '  I N C I D E N T E  ',
        style: TextStyle(color: Colors.white),
      );
      _markerShow = false;
      _fitlterButton = true;
      _filterMenu = false;
      _indicenteBtn = () {
        markerAddPreview();
      };
    });
  }

  //Adding a Marker
  void markerAddPreview() {
    setState(() {
      _iconRecordBtn = Icon(
        Icons.check,
        color: Colors.white,
      );
      _phraseRecordBtn = Text(
        '  R E P O R T A R  ',
        style: TextStyle(color: Colors.white),
      );
      _markerShow = true;
      _fitlterButton = false;
      _indicenteBtn = () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MarkerAddPage(_lastMapPosition)));
        normalPreview();
      };
    });
  }

  //Real-time markers update
  void updateMarkers(bool function) async {
    void marker(
        String title,
        String user,
        String descripcion,
        String date,
        String time,
        String commentDoc,
        int _saferDayMarker,
        var latitude,
        var longitude,
        String documentId) {
      setState(() {
        final int markerCount = _markers.length;
        _markers.add(Marker(
            markerId: MarkerId(markerCount.toString()),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: title,
                snippet: 'Por: ' + user,
                onTap: () => Navigator.of(context).pushNamed('/markerDetails',
                    arguments: MarkerDetailsA(title, descripcion, user, date,
                        time, documentId, latitude, longitude, commentDoc)))));
      });
    }

    if (function) {
      setState(() {
        _markers.clear();
      });
    } else {
      _markers.clear();
      QuerySnapshot querySnapshot =
          await Firestore.instance.collection('locations').getDocuments();
      var list = querySnapshot.documents;
      list.forEach((document) {
        String title = document.data['name'];
        String user = document.data['user'];
        String descripcion = document.data['descripcion'];
        String date = document.data['fecha'];
        String time = document.data['hora'];
        String commentDoc = document.data['comments_Id'];
        int _saferDayMarker = document.data['saferDay'];
        var latitude = document.data['latitude'];
        var longitude = document.data['longitude'];

        if (_currtime == 1) {
          if (_saferDayMarker > _todaySaferDay - 7) {
            marker(title, user, descripcion, date, time, commentDoc,
                _saferDayMarker, latitude, longitude, document.documentID);
          }
        } else if (_currtime == 2) {
          if (_saferDayMarker == _todaySaferDay) {
            marker(title, user, descripcion, date, time, commentDoc,
                _saferDayMarker, latitude, longitude, document.documentID);
          }
        } else {
          marker(title, user, descripcion, date, time, commentDoc,
              _saferDayMarker, latitude, longitude, document.documentID);
        }
      });
    }
  }
}

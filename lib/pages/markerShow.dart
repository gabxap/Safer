import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safer/arguements/MarkerShowA.dart';
import 'package:safer/colors/colors.dart';

class MarkerShowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarkerShowPageState();
  }
}

class _MarkerShowPageState extends State<MarkerShowPage> {
  //Map
  CameraPosition _initialPosition;
  GoogleMapController mapController;
  LatLng _lastMapPosition;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final MarkerShowA args = ModalRoute.of(context).settings.arguments;

    //MiniMap
    _initialPosition =
        CameraPosition(target: LatLng(args.latitude, args.longitude), zoom: 20);
    _lastMapPosition = LatLng(args.latitude, args.longitude);
    _markers.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(args.latitude, args.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: args.title,
        )));
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        backgroundColor: Color(SaferColors().getSaferGreen()),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        onMapCreated: onMapCreated,
        markers: _markers,
        onCameraMove: onCameraMove,
      ),
    );
  }

  void onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safer/arguements/MarkerDetailsA.dart';

class CrimeFeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CrimeFeedPageState();
  }
}

class _CrimeFeedPageState extends State<CrimeFeedPage>
    with AutomaticKeepAliveClientMixin<CrimeFeedPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('locations')
          .orderBy('saferDay', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 5),
              child: buildList(context, snapshot.data.documents[index]),
            );
          },
        );
      },
    );
  }

  Widget buildList(BuildContext context, DocumentSnapshot document) {
    String title = document['name'];
    String descripcion = document['descripcion'];
    String user = document['user'];
    String date = document['fecha'];
    String time = document['hora'];
    String commentDoc = document['comments_Id'];
    var latitude = document.data['latitude'];
    var longitude = document.data['longitude'];

    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/markerDetails',
              arguments: MarkerDetailsA(title, descripcion, user, date, time,
                  document.documentID, latitude, longitude, commentDoc));
        },
        child: Card(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                document['name'],
                textAlign: TextAlign.justify,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Reportado por ${document['user']}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //color: Colors.red,

                    fontSize: 13),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      Text(document['fecha'])
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Text(document['hora'])
                    ],
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  @override
  bool get wantKeepAlive => true;
}

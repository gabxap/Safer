import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safer/arguements/MarkerDetailsA.dart';
import 'package:safer/arguements/MarkerShowA.dart';
import 'package:safer/colors/colors.dart';

class MarkerDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarkerDetailsState();
  }
}

class _MarkerDetailsState extends State<MarkerDetails> {
  String _user;
  String _commentDoc;
  int _commentCounter = 0;

  @override
  void initState() {
    inputData().then((value) async {
      var document =
          await Firestore.instance.collection('users').document(value);
      await document.get().then((datasnapshot) {
        _user = datasnapshot.data['nombre'];
      });
    });

    super.initState();
  }

  final TextEditingController _commentController = TextEditingController();
  Firestore firestore = Firestore.instance;
  var now = DateTime.now();
  String document;

  @override
  Widget build(BuildContext context) {
    final MarkerDetailsA args = ModalRoute.of(context).settings.arguments;
    document = args.documentName;
    _commentDoc = args.commentsDoc;

    _getComments();

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
          backgroundColor: Color(SaferColors().getSaferGreen()),
        ),
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(3)),
            Card(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(args.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.account_circle),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      args.user,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 30, bottom: 30, right: 5, left: 5),
                  child: Text(
                    args.descripcion,
                    style: TextStyle(),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.date_range),
                        Text(args.date)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        Text(args.time),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.map,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Text(' Mostrar en el mapa',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/markerShow',
                        arguments: MarkerShowA(
                            args.title, args.latitude, args.longitude));
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
              ],
            )),
            _getComments()
          ],
        ),
        bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
                child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Comentario',
                  contentPadding: const EdgeInsets.only(
                      left: 20.0, bottom: 20.0, top: 20.0),
                  suffixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                    child: IconButton(
                      iconSize: 16.0,
                      icon: Icon(
                        Icons.send,
                        color: Colors.green,
                      ),
                      onPressed: _addComment,
                    ),
                  )),
            ))));
  }

  StreamBuilder _getComments() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('comments')
          .document(_commentDoc)
          .collection('values')
          .orderBy('order', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Cargando..');
        } else {
          _commentCounter = snapshot.data.documents.length;
        }

        return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return _buildList(context, snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            document['comment'],
            textAlign: TextAlign.justify,
          ),
          Text(
            "Por ${document['user']}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }

  void commentCounter() async {
    var commentDoc =
        await Firestore.instance.collection('comments').document(_commentDoc);
    int counter;
    await commentDoc.get().then((datasnapshot) {
      counter = datasnapshot.data['n_comments'] + 1;
      commentDoc.updateData({'n_comments': counter});
    });
  }

  void _addComment() async {
    var _comment = _commentController.text;
    var _day = now.day;
    var _month = now.month;
    var _year = now.year;
    var _date = [_day, _month, _year];

    if (_comment != '') {
      try {
        commentCounter();
        await firestore
            .collection('comments')
            .document(_commentDoc)
            .collection('values')
            .add({
          'user': _user,
          'comment': _comment,
          'date': _date,
          'likes': 0,
          'order': _commentCounter
        });
        _commentController.text = '';
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }
}

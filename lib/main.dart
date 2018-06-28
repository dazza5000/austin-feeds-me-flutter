import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Austin Feeds Me',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Austin Feeds Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> allData = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('events').orderByChild('time').startAt(new DateTime.now().millisecondsSinceEpoch).once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for (var key in keys) {
        if (data[key]['food']) {
          allData.add(data[key]['name'] + DateTime.fromMillisecondsSinceEpoch(data[key]['time']).toString());
        }
      }
      setState(() {
        print("allData length is: "+allData.length.toString());
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child: allData.length == 0
              ? new Text(' No Data is Available')
              : new ListView.builder(
            itemCount: allData.length,
            itemBuilder: (_, index) {
              return _buildRow(allData[index]);
            },
          )),
    );
  }

  Widget _buildRow(String rowTitle) {
    return new Row(
        children: <Widget>[
    new Expanded(
    child: new Text(rowTitle),
    ),]);
  }
}
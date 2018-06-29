import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:intl/intl.dart';

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
  List<AustinFeedsMeEvent> events = [];
  int currentTab = 0;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('events')
        .orderByChild('time')
        .startAt(new DateTime.now().millisecondsSinceEpoch)
        .once()
        .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for (var key in keys) {
        if (data[key]['food']) {
          events.add(new AustinFeedsMeEvent(
              name: data[key]['name'],
              time: data[key]['time'],
              description: data[key]['description'],
              url: data[key]['event_url']));
        }
      }
      setState(() {
        events.sort((a, b) {
          return a.time.compareTo(b.time);
        });
        print("allData length is: " + events.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar navBar = new BottomNavigationBar(
      currentIndex: currentTab,
      // Our currentIndex will be the currentTab value. So we need to update this whenever we tab on a new page!
      onTap: (int numTab) {
        // numTab will be the index of the tab that is pressed.
        setState(() {
          // Setting the state so we can show our new page.
          print("Current tab: " +
              numTab.toString()); // Printing for debugging reasons.
          currentTab =
              numTab; // Updating our currentTab with the tab that is pressed [See 43].
          currentPage = pages[
          numTab]; // Updating the page that we'd like to show to the user.
        });
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
            icon: new Icon(Icons.list), title: new Text("List")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.map), title: new Text("Map")),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child: events.length == 0
              ? new Center(child: new Text('Loading...'))
              : new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (_, index) {
              return _buildRow(events[index]);
            },
          )),
      bottomNavigationBar: new BottomAppBar(
        child: navBar,
      ),
    );
  }

  Widget _buildRow(AustinFeedsMeEvent event) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(event.time);
    String date = new DateFormat.yMMMMEEEEd().format(dateTime);

    String time = new DateFormat.jm().format(dateTime);

    return new GestureDetector(
        child: new Card(
            child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0),
              ),
              Image.network(
                'https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg',
                width: 77.0,
                height: 77.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
              ),
              new Expanded(
                child: new Text(event.name, style: TextStyle(fontSize: 20.0,)),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(date),
                  new Text(time),
                ],
              ),
            ])),
        onTap: () => eventTapped(event));
  }

  eventTapped(AustinFeedsMeEvent event) {
    _launchURL(event.url);
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

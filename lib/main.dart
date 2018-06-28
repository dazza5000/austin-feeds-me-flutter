import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';

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
  int currentTab = 0; // Index of currently opened tab.
  List<Widget> pages; // List of all pages that can be opened from our BottomNavigationBar.
  // Index 0 represents the page for the 0th tab, index 1 represents the page for the 1st tab etc...
  Widget currentPage; // Page that is open at the moment.

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('events').orderByChild('time').startAt(new DateTime.now().millisecondsSinceEpoch).once().then((DataSnapshot snap) {
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
        print("allData length is: "+events.length.toString());
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar navBar = new BottomNavigationBar(
      currentIndex: currentTab, // Our currentIndex will be the currentTab value. So we need to update this whenever we tab on a new page!
      onTap: (int numTab) { // numTab will be the index of the tab that is pressed.
        setState(() { // Setting the state so we can show our new page.
          print("Current tab: " + numTab.toString()); // Printing for debugging reasons.
          currentTab = numTab; // Updating our currentTab with the tab that is pressed [See 43].
          currentPage = pages[numTab]; // Updating the page that we'd like to show to the user.
        });
      },
      items: <BottomNavigationBarItem>[ // Visuals, see docs for more information: https://docs.flutter.io/flutter/material/BottomNavigationBar-class.html
        new BottomNavigationBarItem( //numTab 0
            icon: new Icon(Icons.list),
            title: new Text("List")
        ),
        new BottomNavigationBarItem( //numTab 1
            icon: new Icon(Icons.map),
            title: new Text("Map")
        ),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child: events.length == 0
              ? new Text(' No Data is Available')
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
    return new GestureDetector(
        child: new Card(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
        children: <Widget>[
    new Expanded(
    child: new Text(event.name),
    ),
    new Text(DateTime.fromMillisecondsSinceEpoch(event.time).toString()),
        ])
    ),
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

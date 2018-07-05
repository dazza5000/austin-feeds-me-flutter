import 'package:flutter/material.dart';
import 'package:austin_feeds_me/views/event_map_view.dart';
import 'package:austin_feeds_me/views/event_list_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeViewState createState() => new HomeViewState();
}

class HomeViewState extends State<HomeView> {

  int currentTab = 0;
  EventListView myHomePage = new EventListView();
  EventMapView mapPage = new EventMapView();
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    pages = [myHomePage, mapPage]; // Populate our pages list.
    currentPage = myHomePage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Here we create our BottomNavigationBar.
    final BottomNavigationBar navBar = new BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (int numTab) {
        setState(() {
          currentTab = numTab;
          currentPage = pages[numTab];
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
      bottomNavigationBar: navBar, // Assigning our navBar to the Scaffold's bottomNavigationBar property.
      body: currentPage, // The body will be the currentPage. Which we update when a tab is pressed.
    );
  }
}
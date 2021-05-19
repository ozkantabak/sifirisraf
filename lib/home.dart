import 'package:flutter/material.dart';
import 'package:sifirisraf/pages/flows.dart';
import 'package:sifirisraf/pages/profile.dart';
import 'package:sifirisraf/pages/search.dart';
import 'package:sifirisraf/utils/variables.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  List pageoptions = [
    FlowsPage(),
    SearchPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.black,
          currentIndex: page,
          items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
              title: Text(
              "Gönderiler",
              style: mystyle(20),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            ),
            title: Text(
              "Arama",
              style: mystyle(20),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 32,
            ),
            title: Text(
              "Profil",
              style: mystyle(20),
            ))
      ]),
    );
  }
}

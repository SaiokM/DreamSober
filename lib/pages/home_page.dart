// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dreamsober/screens/drinkpage.dart';
import 'package:dreamsober/screens/graph.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:dreamsober/screens/profileplaceholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dreamsober/pages/about.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static String route = "/home/";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String userUID = FirebaseAuth.instance.currentUser!.uid;
  static int _selectedIdx = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetList = <Widget>[
    Text("Bed", style: optionStyle),
    DrinkPage(),
    ChartPage(),
    ProfilePage(),
  ];

  final Color mainColor = const Color.fromARGB(255, 42, 41, 50);

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetList[_selectedIdx],
      ),
      appBar: AppBar(backgroundColor: Colors.brown[900],),
      drawer: _drawer(context),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.brown[900],
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                  child: Text(
                'L O G O',
                style: TextStyle(fontSize: 35, color: Colors.white),
              )),
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text(
                'About',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => InfoPage()));
              },
            ),
            ListTile(
              onTap: () {
                signUserOut();
                //Navigator.pop(context);
              },
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Log out',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      color: Colors.brown[900],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GNav(
            backgroundColor: Color.fromRGBO(62, 39, 35, 1),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromRGBO(109, 76, 65, 1),
            gap: 8,
            padding: EdgeInsets.all(16),
            selectedIndex: _selectedIdx,
            onTabChange: (idx) {
              //log(idx.toString());
              setState(() {
                _selectedIdx = idx;
              });
            },
            tabs: [
              GButton(
                icon: Icons.bed,
                text: 'Bed',
              ),
              GButton(
                icon: Icons.wine_bar,
                text: 'Alcohol',
              ),
              GButton(
                icon: Icons.show_chart,
                text: 'Graphs',
              ),
              GButton(
                icon: Icons.person,
                text: "Profile Page",
              )
            ]),
      ),
    );
  }
}

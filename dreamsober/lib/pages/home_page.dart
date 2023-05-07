// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dreamsober/pages/about.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  static int _selectedIdx = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetList = <Widget>[
    Text("Bed", style: optionStyle),
    Text("Drink", style: optionStyle),
    Text("Graph", style: optionStyle),
  ];

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      drawer: _drawer(context),
      body: Center(
        child: _widgetList[_selectedIdx],
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
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
                //signUserOut();
                Navigator.pop(context);
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
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(208, 66, 66, 66),
            gap: 8,
            padding: EdgeInsets.all(16),
            selectedIndex: _selectedIdx,
            onTabChange: (idx) {
              log(idx.toString());
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
            ]),
      ),
    );
  }
}

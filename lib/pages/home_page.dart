// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_const_constructors_in_immutables

import 'package:dreamsober/models/user.dart';
import 'package:dreamsober/pages/report.dart';
import 'package:dreamsober/screens/drinkpage.dart';
import 'package:dreamsober/screens/graph.dart';
import 'package:dreamsober/screens/impacttest.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dreamsober/pages/about.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

import '../components/square_tile.dart';

class HomePage extends StatefulWidget {
  final String userUID;
  HomePage({super.key, required this.userUID});
  static String route = "/home/";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamController<int> stream_controller;

  @override
  void initState() {
    super.initState();
    stream_controller = StreamController<int>.broadcast();
  }

  @override
  void dispose() {
    stream_controller.close();
    super.dispose();
  }

  static int _selectedIdx = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void signOut() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  final Color mainColor = const Color.fromARGB(255, 42, 41, 50);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetList = <Widget>[
      ReportPage(),
      DrinkPage(userUID: widget.userUID),
      ChartPage(userUID: widget.userUID),
      ProfilePage(userUID: widget.userUID), // 4 Giulio: add userUID to profPage
    ];

    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID).child("User");

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        CurrentUser _currentUser = CurrentUser("", 0, 0, 0, "");
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          Map<String, dynamic> user =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          _currentUser = CurrentUser.fromJson(user);
        }
        return Scaffold(
          body: Center(
            child: _widgetList[_selectedIdx],
          ),
          appBar: AppBar(
            backgroundColor: Colors.brown[900],
          ),
          drawer: _drawer(context, _currentUser),
          bottomNavigationBar: _bottomNavBar(context),
        );
      },
    );
  }

  Widget _drawer(BuildContext context, CurrentUser user) {
    //log(widget.userUID);
    return Drawer(
      child: Container(
        color: Colors.brown[900],
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Avaible from the next update"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    imagePath: 'assets/profileimg.png'),
                DrawerHeader(
                  child: Center(
                    child: Text(
                      user.name,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
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
                signOut();
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
                icon: Icons.report,
                text: 'Report',
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

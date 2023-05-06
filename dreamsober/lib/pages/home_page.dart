// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dreamsober/pages/about.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(/*
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],*/
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children:  [
              DrawerHeader(
                child: Center(child:Text(
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InfoPage()));
              },
              ),
              ListTile(
                onTap: signUserOut,
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Log out',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
          child: Text(
        'Logged IN AS:' + user.email!,
        style: TextStyle(fontSize: 20),
      )),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Color.fromARGB(208, 66, 66, 66),
              gap: 8,
              padding: EdgeInsets.all(16),
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
                  icon: Icons.calendar_month,
                  text: 'Calendar',
                ),
              ]),
        ),
      ),
    );
  }
}

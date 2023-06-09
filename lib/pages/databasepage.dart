// ignore_for_file: unused_import, unused_field, prefer_const_constructors

import 'dart:developer';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/pages/drinkpage.dart';
import 'package:dreamsober/pages/managedrink.dart';
import 'package:provider/provider.dart';

class DatabasePage extends StatefulWidget {
  final String userUID = UserPrefs.getUID();
  DatabasePage({super.key});
  static String route = "/list/";
  static String routeName = "Drink Database";

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  //final Color mainColor = const Color.fromARGB(255, 42, 41, 50);
  @override
  Widget build(BuildContext context) {
    log(widget.userUID);
    return FutureBuilder(
      future: _fApp,
      builder: (context, snapshot) {
        //log(DatabasePage.userUID);
        if (snapshot.hasError) {
          return _error(context);
        } else if (snapshot.hasData) {
          return _mainPage(context);
        } else {
          return _wait(context);
        }
      },
    );
  }

  Widget _wait(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(DatabasePage.routeName),
        centerTitle: true,
        backgroundColor: Colors.brown[900],
      ),
      body: Center(
        child: CircularProgressIndicator(
            //color: mainColor,
            ),
      ),
    );
  }

  Widget _error(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[900],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(DatabasePage.routeName),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Text("Error: Something whent wrong"),
      ),
    );
  }

  Widget _mainPage(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[900],
          title: Text(DatabasePage.routeName),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "List of days from database",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  _drinkList(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _drinkList(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID).child("Data");
    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            //log(map.toString());
            List<dynamic> list = [];
            list.clear();
            list = map.keys.toList();
            // Sort List
            list.sort((a, b) {
              return DateTime.parse(a).compareTo(DateTime.parse(b));
            });
            height = list.length < 5 ? list.length * 82 : 400;
            return SizedBox(
              height: height,
              child: Card(
                color: Colors.brown[300],
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, idx) {
                      return Card(
                        child: ListTile(
                          tileColor: Colors.brown[200],
                          title: Text(
                              "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(map[list[idx]]['Date'])).split(' ')[0].replaceAll("-", "/")}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Alcohol Drank: ${map[list[idx]]["TotalAlcohol"].toString()}ml"),
                              Text(
                                  "Money Spent: ${map[list[idx]]["TotalSpent"].toString()}€"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              context
                                  .read<DailyDrinkDB>()
                                  .loadFromJson(map[list[idx]]);
                              context.read<DailyDrinkDB>().mod(false);
                              Navigator.pop(context);
                            },
                          ),
                          onLongPress: () {
                            final snackBar = SnackBar(
                              content: const Text('Daily drink list deleted'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            context
                                .read<DailyDrinkDB>()
                                .removeDay(dbRef, list[idx]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 380,
              child: Card(
                color: Color.fromARGB(255, 170, 167, 196),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "No entries found!",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 81, 81, 81)),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return CircularProgressIndicator(
              //color: mainColor,
              );
        }
      },
    );
  }
}

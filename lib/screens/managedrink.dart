// ignore_for_file: prefer_const_constructors, unused_import

import 'package:dreamsober/screens/drinkpage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:provider/provider.dart';

class ManageDrinkPage extends StatefulWidget {
  ManageDrinkPage({super.key});
  static String route = '/drinklist/';
  static String routeName = 'Is everything right?';
  final user = FirebaseAuth.instance.currentUser!;
  static String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<ManageDrinkPage> createState() => _ManageDrinkPageState();
}

class _ManageDrinkPageState extends State<ManageDrinkPage> {
  final Color mainColor = const Color.fromARGB(255, 42, 41, 50);

  final List<String> imgs = [
    'assets/beer.png',
    'assets/cocktail.png',
    'assets/whiskey.png',
    'assets/wine-bottle.png'
  ];
  final List<Drink> drinks = [
    Drink('Beer', 4, 500, 5),
    Drink('Cocktail', 8, 200, 8),
    Drink('Super Alcoholics', 40, 40, 6),
    Drink('Wine', 12, 150, 4)
  ];

  void _updateCurrentUser() {
    ManageDrinkPage.userUID = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    _updateCurrentUser();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(ManageDrinkPage.routeName),
        centerTitle: true,
        backgroundColor: Colors.brown[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                "Selected Date: ${DateFormat('dd-MM-yyyy').format(context.read<DailyDrinkDB>().date).split(' ')[0].replaceAll("-", "/")}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              _drinkList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _floatButton(context),
    );
  }

  Widget _drinkList(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 170, 167, 196),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: drinks.length,
          itemBuilder: (context, idx) {
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                tileColor: Color.fromARGB(255, 147, 145, 170),
                title: Text(
                  drinks[idx].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                //titleAlignment: ListTileTitleAlignment.center, //4 Giulio Check thiss
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alcohol Content: ~ ${drinks[idx].perc.toString()} %",
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      "Volume: ~ ${drinks[idx].volume.toString()} ml",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                leading: Image.asset(
                  imgs[idx],
                  height: 50,
                ),
                trailing: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Consumer<DailyDrinkDB>(builder: (context, dailyDB, _) {
                    return Text(
                      dailyDB.getDrinkCount(drinks[idx].name).toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _floatButton(BuildContext context) {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref()
        .child(ManageDrinkPage.userUID)
        .child("Data");
    return FloatingActionButton(
      onPressed: () {
        context.read<DailyDrinkDB>().saveDay(dbRef);
        String msg = 'Daily drink list saved!';
        if (!context.read<DailyDrinkDB>().modify) {
          msg = 'Daily drink list modified!';
        }
        final snackBar = SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<DailyDrinkDB>().resetDB();
        if (!context.read<DailyDrinkDB>().modify) {
          context.read<DailyDrinkDB>().mod(true);

          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      backgroundColor: Colors.brown[900],
      child: Icon(Icons.save),
    );
  }
}

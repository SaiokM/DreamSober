// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/models/impact.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReportPage extends StatefulWidget {
  final String userUID = UserPrefs.getUID();
  ReportPage({super.key});

  static String route = "/report/";
  static String routeName = "Weekly Report";
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final List<String> imgs = [
    'assets/beer.png',
    'assets/cocktail.png',
    'assets/whiskey.png',
    'assets/wine-bottle.png'
  ];
  List<String> drinkList = [
    'beers',
    'cocktails',
    'super alcoholics',
    'wine glasses'
  ];
  final List<Drink> drinks = [
    Drink('Beer', 4, 500, 5),
    Drink('Cocktail', 8, 200, 8),
    Drink('Super Alcoholics', 40, 40, 6),
    Drink('Wine', 12, 150, 4)
  ];

  final String today = DateTime.now().toString().split(' ')[0];
  late final List<String> thisWeek;

  @override
  void initState() {
    thisWeek = _generateWeek(today);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromRGBO(215, 204, 200, 1),
      child: _weeklyList(context),
    );
  }

  List<String> _generateWeek(String day) {
    List<String> weekList = ["", "", "", "", "", "", ""];
    List date = day.split("-"); //[YYYY, MM, DD]
    for (int i = 1; i <= 7; i++) {
      weekList[i - 1] = DateTime(
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(date[2]) -
                  DateTime.parse(day).weekday +
                  i) //YYYY, MM, DD
          .toString()
          .split(' ')[0];
    }
    return weekList;
  }

  Future<Map<dynamic, dynamic>> sleepData() async {
    Map<String, SleepDay> impactSleep = {};
    impactSleep = await Impact.getSleepRangeData(
        thisWeek[0], thisWeek[thisWeek.length - 1]);
    return impactSleep;
  }

  Widget _weeklyList(BuildContext context) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID).child("Data");

    //log(thisWeek.toString());

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            var totAlc = 0;
            var totBeer = 0;
            var totCocktails = 0;
            var totSuper = 0;
            var totWine = 0;
            for (String day in thisWeek) {
              if (map.keys.contains(day)) {
                totAlc += int.parse(map[day]["TotalAlcohol"].toString());
                totBeer += int.parse(map[day]["Drinks"]['Beer'].toString());
                totCocktails +=
                    int.parse(map[day]["Drinks"]['Cocktail'].toString());
                totSuper += int.parse(
                    map[day]["Drinks"]['Super Alcoholics'].toString());
                totWine += int.parse(map[day]["Drinks"]['Wine'].toString());
              }
            }
            List<int> totList = [totBeer, totCocktails, totSuper, totWine];

            //log(totAlc.toString());
            return Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _weekDrinks(context, totList),
                  _weekGrid(context, totList),
                ],
              ),
            );
          } else {
            return Text("DB Empty");
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _weekDrinks(BuildContext context, List<int> totList) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 200,
        child: Card(
            color: Colors.brown[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  "This week you drunk a total of",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      childAspectRatio: 2.3,
                      crossAxisCount: 2,
                      children: List.generate(4, (idx) {
                        return SizedBox(
                          height: 30,
                          child: Card(
                            color: Colors.brown[200],
                            child: Center(
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  totList[idx].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  drinkList[idx],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10),
                                ),
                                leading: SizedBox(
                                  height: 45,
                                  child: Image.asset(
                                    imgs[idx],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _weekGrid(BuildContext context, List<int> totList) {
    double totSpent = 0;
    for (int i = 0; i < 4; i++) {
      totSpent += drinks[i].price * totList[i];
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 400,
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          childAspectRatio: 1,
          crossAxisCount: 2,
          children: List.generate(4, (idx) {
            return Card(
              color: Colors.brown[300],
              child: SizedBox(
                height: 30,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Card(
                    color: Colors.brown[200],
                    child: (idx == 0)
                        ? _money(context, totSpent)
                        : (idx == 1)
                            ? _sleep(context)
                            : SizedBox(),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _money(BuildContext context, double totSpent) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "This week you spent",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Center(
            child: Text(
              "$totSpent€",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _sleep(BuildContext context) {
    return FutureBuilder(
        future: sleepData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, SleepDay> sleepMap =
                snapshot.data as Map<String, SleepDay>;
            // sleepMap contiene i dati del sonno della settimana corrente
            // per estrarre i dati di ogni giorno guardare il file sleepday.dart
            // La variabile thisWeek contiene i giorni della settimana in formato
            // YYYY-MM-DD come stringa, usate i valori per accedere ai dati del
            // all'interno di sleepMap (dovrebbero essere quindi gli stessi dentro
            // sleepMap.keys).
            // Esempio:
            /*
          SleepDay lunedi = sleepMap[thisWeek[0]]!; //null check
          lunedi.duration;
          lunedi.minAsleep;
          */

            // NB: usate un FutureBuilder, come future mettete sleepData(), e mettete
            // SEMPRE un if(snapshot.hasData){
            // ...
            // } else {
            //  return Center(child: CircularPrograssiIndicator);
            // }
            // così mentre carica i dati ci sarà il coso che gira

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "This week you slept\nan average of",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "hs",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';

class ReportPage extends StatefulWidget {
  final String userUID;
  const ReportPage({super.key, required this.userUID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromARGB(255, 252, 216, 204),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            "How did you do this Week?",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _dailyReport(context),
                _graph(context),
                _alchExpen(context),
              ],
            ),
          ),
        ],
      ),
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

  Widget _dailyReport(BuildContext context) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID).child("Data");

    //log(thisWeek.toString());

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.snapshot.value != null) {
            String today = DateTime.now().toString().split(' ')[0];
            List<String> thisWeek = _generateWeek(today);

            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            var totAlc = 0;
            for (String day in thisWeek) {
              if (map.keys.contains(day)) {
                totAlc += int.parse(map[day]["TotalAlcohol"].toString());
              }
            }
            log(totAlc.toString());
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 150,
                child: Card(
                  color: Colors.brown[300],
                  child: ListTile(
                    title: Text("This week you drunk:"),
                    subtitle: Text(
                      "$totAlc ml",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Text("DB Empty");
          }
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _graph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 150,
        child: Card(
          color: Colors.brown[300],
          child: ListTile(
            title: Text("cacca"),
          ),
        ),
      ),
    );
  }

  Widget _alchExpen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 150,
        child: Card(
          color: Colors.brown[300],
          child: ListTile(
            title: Text("cacca"),
          ),
        ),
      ),
    );
  }
}

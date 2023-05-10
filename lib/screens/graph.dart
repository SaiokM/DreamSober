// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dreamsober/bar_graph/bar_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dreamsober/models/drinkDB.dart';

class ChartPage extends StatelessWidget {
  final String userUID;
  ChartPage({super.key, required this.userUID});
  static String route = "/chart/";
  static String routeName = "Data Chart";

  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  final Color mainColor = const Color.fromARGB(255, 42, 41, 50);
  final Color secondaryColor = Color.fromARGB(255, 146, 138, 122);
  final Color alcColor = Color.fromARGB(255, 61, 56, 47);
  final Color sleepColor = Color.fromARGB(255, 114, 99, 78);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fApp,
      builder: (context, snapshot) {
        double height = MediaQuery.of(context).size.height;
        //log(height.toString());
        return Scaffold(
            backgroundColor: Color.fromARGB(255, 159, 159, 159),
            resizeToAvoidBottomInset: false,
            body: (snapshot.hasError)
                ? _error(context)
                : (snapshot.hasData)
                    ? (height < 700)
                        ? SingleChildScrollView(
                            child: _pageBody(context),
                          )
                        : _pageBody(context)
                    : _wait(context));
      },
    );
  }

  Widget _wait(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }

  Widget _error(BuildContext context) {
    return const Center(
      child: Text("Error: Something whent wrong"),
    );
  }

  Widget _pageBody(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                "How well did you sleep?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                color: Color.fromARGB(255, 237, 237, 237),
                child: _graph(context),
              ),
            ],
          ),
          _buttons(context)
        ],
      ),
    );
  }

  Widget _graph(BuildContext context) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(userUID).child("Data");

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            //log(map.toString());
            List<String> dayList = [];
            List<double> alcList = [];
            List<double> sleepList = [];

            dayList.clear();
            alcList.clear();
            sleepList.clear();

            for (var key in map.keys) {
              dayList.add(key);
            }
            // Sort List
            dayList.sort((a, b) {
              return DateTime.parse(a).compareTo(DateTime.parse(b));
            });
            if (dayList.length > 7) {
              dayList.removeRange(0, dayList.length - 7);
            }
            log(dayList[dayList.length - 1].toString());
            for (var day in dayList) {
              alcList.add(map[day]['TotalAlcohol'].toDouble());
              sleepList.add(map[day]['SleepScore'].toDouble());
            }

            //log(dayList.toString());
            //log(alcList.toString());
            //og(sleepList.toString());

            BarData mybarData = BarData(
              dayList: dayList,
              alcList: alcList,
              sleepList: sleepList,
            );
            mybarData.initializeBarData();

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "${DateFormat('dd-MM-yyyy').format(DateTime.parse(dayList[0])).split(' ')[0].replaceAll("-", "/")} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(dayList[dayList.length - 1])).split(' ')[0].replaceAll("-", "/")}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 360,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          width: 50 * dayList.length.toDouble(),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: BarChart(
                              BarChartData(
                                borderData: FlBorderData(
                                  border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    left: BorderSide.none,
                                    bottom: BorderSide(width: 1),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                        drawBehindEverything: true,
                                        sideTitles: _bottomTitles(mybarData)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false))),
                                gridData: FlGridData(show: true),
                                minY: 0,
                                barGroups: mybarData.barData
                                    .map(
                                      (data) => BarChartGroupData(
                                        x: data.x,
                                        barRods: [
                                          BarChartRodData(
                                            width: 15,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            toY: data.y1,
                                            color: alcColor,
                                          ),
                                          BarChartRodData(
                                            width: 15,
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            toY: data.y2,
                                            color: sleepColor,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox(
              //No Entries
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
            color: mainColor,
          );
        }
      },
    );
  }

  SideTitles _bottomTitles(BarData myBarData) {
    return SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(myBarData.dayList[value.toInt()]))
              .split(' ')[0]
              .replaceAll("-", "/");

          return Column(children: [
            SizedBox(height: 9),
            Transform.rotate(
                angle: -math.pi / 10,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ]);
        });
  }

  Widget _buttons(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: 410,
      left: screenWidth / 2 - 75,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: mainColor,
              ),
              onPressed: () {},
              child: Icon(Icons.arrow_left),
            ),
            SizedBox(width: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: mainColor,
              ),
              onPressed: () {},
              child: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:math';
import 'package:dreamsober/models/impact.dart';
import 'package:dreamsober/models/sleepFunction.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/models/sleepday.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dreamsober/bar_graph/bar_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dreamsober/models/drinkDB.dart';

class ChartPage extends StatefulWidget {
  final String userUID = UserPrefs.getUID();
  ChartPage({super.key});
  static String route = "/chart/";
  static String routeName = "Chart Data";

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final Color? mainColor = Colors.brown[900];
  final Color secondaryColor = Color.fromARGB(255, 146, 138, 122);
  final Color alcColor = Color.fromARGB(255, 61, 56, 47);
  final Color sleepColor = Color.fromARGB(255, 114, 99, 78);
  final Color moneyColor = Color.fromARGB(255, 163, 132, 89);

  int dayIdx = 0;
  List<String> refDay = DateTime.now().toString().split(" ")[0].split("-");
  late List<String> weekList;

  @override
  void initState() {
    weekList = _generateWeek(DateTime(int.parse(refDay[0]),
            int.parse(refDay[1]), int.parse(refDay[2]) - dayIdx)
        .toString()
        .split(" ")[0]);
    super.initState();
  }

  void updateWeek() {
    weekList = _generateWeek(DateTime(int.parse(refDay[0]),
            int.parse(refDay[1]), int.parse(refDay[2]) - dayIdx)
        .toString()
        .split(" ")[0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        double height = MediaQuery.of(context).size.height;
        //log(height.toString());
        return Scaffold(
            backgroundColor: Color.fromRGBO(215, 204, 200, 1),
            resizeToAvoidBottomInset: false,
            body: (snapshot.hasError)
                ? _error(context)
                : (snapshot.hasData)
                    ? _pageBody(context)
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
      child: _graph(context),
    )
        //_buttons(context)
        ;
  }

  //generates a list of the days of the current week from a day
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

  //Function to fetch sleep data from impact and alcohol data from firebase db
  Future<List<Map<dynamic, dynamic>>> _graphAlcData() async {
    List<Map> alcSleepList = [];
    Map<dynamic, dynamic> alcMap = {};
    Map<String, SleepDay> impactSleep = {};

    // Firebase
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID).child("Data");
    await dbRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value == null) {}
      alcMap =
          event.snapshot.value as Map<dynamic, dynamic>; // save alcohol data
    });
    // Impact
    impactSleep = await Impact.getSleepRangeData(
        weekList[0], weekList[weekList.length - 1]);
    alcSleepList = [alcMap, impactSleep];
    return alcSleepList;
  }

  Widget _graph(BuildContext context) {
    return FutureBuilder(
        future: _graphAlcData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //dev.log(snapshot.data!.length.toString());
            //log("-----snapshot-----\n${snapshot.data}\n-----snapshot-----");
            Map<dynamic, dynamic> alcMap = snapshot.data![0];
            Map<String, SleepDay> sleepMap =
                snapshot.data![1] as Map<String, SleepDay>;
            //dev.log("-----alcMap------\n$alcMap\n------alcMap------");
            //dev.log("-----sleepMap------\n$sleepMap\n------sleepMap------");
            if (alcMap.isNotEmpty) {
              //log(map.toString());
              List<String> alcdateList = [];
              List<double> alcList = [];
              List<double> sleepList = [];
              List<double> moneyList = [];
              List<double> slpqltList = [];

              for (var key in alcMap.keys) {
                alcdateList.add(key);
              }

              // Sort List
              alcdateList.sort((a, b) {
                return DateTime.parse(a).compareTo(DateTime.parse(b));
              });

              for (var day in weekList) {
                if (alcMap.keys.contains(day)) {
                  alcList.add(alcMap[day]['TotalAlcohol'].toDouble());
                } else {
                  alcList.add(0);
                }
                if (sleepMap.keys.contains(day)) {
                  dev.log(SleepFunction.fromSleepDay(sleepMap[day]!)
                      .SleepQualityDS()
                      .toString());
                  slpqltList.add((SleepFunction.fromSleepDay(sleepMap[day]!)
                                  .SleepQualityDS()! *
                              100)
                          .truncateToDouble() /
                      100);
                  sleepList.add(
                      (sleepMap[day]!.duration / 36).truncateToDouble() / 100);
                } else {
                  slpqltList.add(0);
                  sleepList.add(0);
                }
                if (alcMap.keys.contains(day)) {
                  moneyList.add(alcMap[day]['TotalSpent'].toDouble());
                } else {
                  moneyList.add(0);
                }
              }
              print(sleepList.toString());
              print(slpqltList.toString());
              BarData mybarData = BarData(
                dayList: weekList,
                alcList: alcList,
                sleepList: sleepList,
                moneyList: moneyList,
                slpqltList: slpqltList,
              );
              mybarData.initializeBarData();

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "${DateFormat('dd-MM-yyyy').format(DateTime.parse(weekList[0])).split(' ')[0].replaceAll("-", "/")} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(weekList[weekList.length - 1])).split(' ')[0].replaceAll("-", "/")}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  //legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: alcColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text("Alcohol [ml]"),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: sleepColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text("Sleep Quality"),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: moneyColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text("Money [€]"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: SizedBox(
                            height: 300,
                            width: 60 * 7,
                            child: Container(
                              alignment: Alignment.topCenter,
                              //color: Colors.green,
                              child: BarChart(
                                BarChartData(
                                  barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.transparent,
                                      )),
                                  borderData: FlBorderData(
                                    border: const Border(
                                      top: BorderSide.none,
                                      right: BorderSide.none,
                                      left: BorderSide.none,
                                      bottom: BorderSide(width: 1),
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                      show: true,
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
                                  gridData: FlGridData(show: false),
                                  minY: 0,
                                  maxY: maxList(alcList, sleepList),
                                  barGroups: mybarData.barData
                                      .map(
                                        (data) => BarChartGroupData(
                                          x: data.x,
                                          barRods: [
                                            BarChartRodData(
                                              width: 13,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              toY: data.y1,
                                              color: alcColor,
                                            ),
                                            BarChartRodData(
                                              width: 13,
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                              toY: data.y4,
                                              color: sleepColor,
                                            ),
                                            BarChartRodData(
                                              width: 13,
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                              toY: data.y3,
                                              color: moneyColor,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                swapAnimationDuration: Duration(seconds: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buttons(context)
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
            return const SizedBox(
              //No Entries
              height: 380,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }

  double maxList(List<double> list1, List<double> list2) {
    var max1 = list1.reduce(max) * 1.40;
    var max2 = list2.reduce(max) * 1.40;
    return max(max1, max2);
  }

  SideTitles _bottomTitles(BarData myBarData) {
    List<String> dayList = ["Mon", "Tue", "Wen", "Thu", "Fri", "Sat", "Sun"];
    return SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          String text = dayList[value.toInt()];

          return SideTitleWidget(
            child: Text(text),
            axisSide: meta.axisSide,
            space: 4,
          );
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
              onPressed: () {
                setState(() {
                  dayIdx += 7;
                  updateWeek();
                });
              },
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
              onPressed: () {
                setState(() {
                  dayIdx -= 7;
                  updateWeek();
                });
              },
              child: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}

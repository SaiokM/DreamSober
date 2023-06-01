// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:math';
import 'package:dreamsober/models/impact.dart';
import 'package:dreamsober/models/sleepFunction.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/models/sleepday.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dreamsober/components/bar_graph/bar_data.dart';
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

  final gridColor = Colors.black;
  final titleColor = Colors.black;
  final fashionColor = Colors.red;
  final artColor = Colors.cyan;
  final boxingColor = Colors.green;
  final entertainmentColor = Colors.white;
  final offRoadColor = Colors.yellow;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final Color? mainColor = Colors.brown[900];
  final Color secondaryColor = Color.fromARGB(255, 146, 138, 122);
  final Color alcColor = Color.fromARGB(255, 61, 56, 47);
  final Color sleepColor = Color.fromARGB(255, 114, 99, 78);
  final Color moneyColor = Color.fromARGB(255, 163, 132, 89);

  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;

  int dayIdx = 0;
  //refDay is equal to today's date
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
        //double height = MediaQuery.of(context).size.height;
        //log(height.toString());
        return Scaffold(
            backgroundColor: Color.fromRGBO(215, 204, 200, 1),
            resizeToAvoidBottomInset: false,
            body: (snapshot.hasError)
                ? _error(context)
                : (snapshot.hasData)
                    ? SingleChildScrollView(child: _graph(context))
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
    var event = await dbRef.once();
    if (event.snapshot.value != null) {
      alcMap = event.snapshot.value as Map<dynamic, dynamic>;
    }
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
            if (alcMap.isNotEmpty || sleepMap.isNotEmpty) {
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

              double meanEfficiency = 0;
              double meanLatency = 0;
              double meanDuration = 0;
              double meanWaso = 0;
              double meanPhases = 0;

              for (var day in weekList) {
                if (alcMap.keys.contains(day)) {
                  alcList.add(alcMap[day]['TotalAlcohol'].toDouble());
                  moneyList.add(alcMap[day]['TotalSpent'].toDouble());
                } else {
                  alcList.add(0);
                  moneyList.add(0);
                }
                if (sleepMap.keys.contains(day) && !sleepMap[day]!.emptyDay) {
                  SleepFunction currentDay =
                      SleepFunction.fromSleepDay(sleepMap[day]!);
                  meanDuration += currentDay.SleepDuration()![1] / 7;
                  meanLatency += currentDay.SleepLatency()![1] / 7;
                  meanEfficiency += currentDay.SleepEfficiency()![1] / 7;
                  meanWaso += currentDay.WASO()![1] / 7;
                  meanPhases += currentDay.SleepPhases()![3] / 7;

                  slpqltList.add(currentDay.SleepQualityDS()!);
                  sleepList.add(
                      (sleepMap[day]!.duration! / 36).truncateToDouble() / 100);
                } else {
                  slpqltList.add(0);
                  sleepList.add(0);
                }
              }
              List<MeanListData> meanList = [
                MeanListData(
                  color: Colors.brown,
                  values: [
                    meanEfficiency.truncateToDouble(),
                    meanLatency.truncateToDouble(),
                    meanDuration.truncateToDouble(),
                    meanWaso.truncateToDouble(),
                    meanPhases.isNaN ? 0 : meanPhases.truncateToDouble(),
                  ],
                )
              ];
              print(meanList[0].values);
              BarData mybarData = BarData(
                dayList: weekList,
                alcList: alcList,
                sleepList: sleepList,
                moneyList: moneyList,
                slpqltList: slpqltList,
              );
              mybarData.initializeBarData();

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                    _barChart(context, mybarData),
                    _buttons(context),
                    SizedBox(height: 20),
                    Text(
                      "${DateFormat('dd-MM-yyyy').format(DateTime.parse(weekList[0])).split(' ')[0].replaceAll("-", "/")} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(weekList[weekList.length - 1])).split(' ')[0].replaceAll("-", "/")}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _radGraph(context, meanList),
                    _buttons(context),
                  ],
                ),
              );
            } else {
              return SizedBox(
                //No Entries
                height: 380,
                child: Card(
                  color: Color.fromARGB(255, 170, 167, 196),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 200,
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
                          _buttons(context),
                        ],
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

  Widget _barChart(BuildContext context, BarData mybarData) {
    return SizedBox(
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
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false))),
                    gridData: FlGridData(show: false),
                    minY: 0,
                    maxY: maxList(mybarData.alcList, mybarData.sleepList,
                        mybarData.slpqltList),
                    barGroups: mybarData.barData
                        .map(
                          (data) => BarChartGroupData(
                            x: data.x,
                            barRods: [
                              BarChartRodData(
                                width: 13,
                                borderRadius: BorderRadius.circular(2),
                                toY: data.y1,
                                color: alcColor,
                              ),
                              BarChartRodData(
                                width: 13,
                                borderRadius: BorderRadius.circular(1),
                                toY: data.y4,
                                color: sleepColor,
                              ),
                              BarChartRodData(
                                width: 13,
                                borderRadius: BorderRadius.circular(1),
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
    );
  }

  Widget _radGraph(BuildContext context, List<MeanListData> meanList) {
    return SizedBox(
      height: 350,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.circle,
          dataSets: showingDataSets(meanList),
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.05,
          titleTextStyle: TextStyle(
              color: widget.titleColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
          getTitle: (index, angle) {
            final usedAngle =
                relativeAngleMode ? angle + angleValue : angleValue;
            switch (index) {
              case 0:
                return RadarChartTitle(
                  text: 'Efficiency',
                  angle: usedAngle,
                );
              case 1:
                return RadarChartTitle(
                  text: 'Latency',
                  angle: usedAngle,
                );
              case 2:
                return RadarChartTitle(
                  text: 'Duration',
                  angle: usedAngle,
                );
              case 3:
                return RadarChartTitle(
                  text: 'WASO',
                  angle: usedAngle,
                );
              case 4:
                return RadarChartTitle(
                  text: 'Phases',
                  angle: usedAngle,
                );
              default:
                return const RadarChartTitle(text: '');
            }
          },
          tickCount: 4,
          ticksTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
          tickBorderData: const BorderSide(color: Colors.black),
          gridBorderData: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets(List<MeanListData> meanList) {
    return meanList.asMap().entries.map((entry) {
      final rawDataSet = entry.value;

      return RadarDataSet(
        fillColor: rawDataSet.color.withOpacity(0.5),
        borderColor: rawDataSet.color,
        borderWidth: 2.5,
        entryRadius: 5,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
      );
    }).toList();
  }

  double maxList(List<double> list1, List<double> list2, List<double> list3) {
    var max1 = list1.reduce(max) * 1.40;
    var max2 = list2.reduce(max) * 1.40;
    var max3 = list3.reduce(max) * 1.40;
    //dev.log("$list1\n$list2\n$list3");
    return [max1, max2, max3].reduce(max);
  }

  SideTitles _bottomTitles(BarData myBarData) {
    List<String> dayList = ["Mon", "Tue", "Wen", "Thu", "Fri", "Sat", "Sun"];
    return SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          String text = dayList[value.toInt()];

          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 4,
            child: Text(text),
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

class MeanListData {
  MeanListData({
    required this.color,
    required this.values,
  });

  final Color color;
  final List<double> values;
}

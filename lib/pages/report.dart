// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:dreamsober/models/sleepFunction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/models/impact.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:d_chart/d_chart.dart';

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

  /*
    Since in impact there are some weeks where there isn't data,
    to illustrate the functionality of the ReportPage we fixed 
    the current day in a week with known sleep data.
  */
  //final String today = DateTime.now().toString().split(' ')[0];
  final String today = "2023-05-06"; //change this date to change the week
  late final List<String> thisWeek;
  late final int weekDay;

  @override
  void initState() {
    thisWeek = _generateWeek(today);
    weekDay = DateTime.parse(today).weekday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return FutureBuilder(
        future: _AlcSleepData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> alcMap = snapshot.data![0];
            Map<String, SleepDay> sleepMap =
                snapshot.data![1] as Map<String, SleepDay>;
            if (sleepMap.isNotEmpty && alcMap.isNotEmpty) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      _sleep(context, sleepMap),
                      _weeklyList(context, alcMap),
                      _moneyKcal(context, alcMap),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text("No entries in the database"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // Future function to fetch alcool data from firebase and sleep data
  // from Impact
  Future<List<Map<dynamic, dynamic>>> _AlcSleepData() async {
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
        thisWeek[0], thisWeek[thisWeek.length - 1]);
    alcSleepList = [alcMap, impactSleep];
    return alcSleepList;
  }

  // Creates a list of the days of the current week
  // from the current day
  List<String> _generateWeek(String day) {
    List<String> weekList = ["", "", "", "", "", "", ""];
    List<String> date = day.split("-"); //[YYYY, MM, DD]
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

  Widget _weeklyList(BuildContext context, Map<dynamic, dynamic> map) {
    if (map.isNotEmpty) {
      var totAlc = 0;
      var totBeer = 0;
      var totCocktails = 0;
      var totSuper = 0;
      var totWine = 0;
      for (String day in thisWeek) {
        if (map.keys.contains(day)) {
          totAlc += int.parse(map[day]["TotalAlcohol"].toString());
          totBeer += int.parse(map[day]["Drinks"]['Beer'].toString());
          totCocktails += int.parse(map[day]["Drinks"]['Cocktail'].toString());
          totSuper +=
              int.parse(map[day]["Drinks"]['Super Alcoholics'].toString());
          totWine += int.parse(map[day]["Drinks"]['Wine'].toString());
        }
      }
      List<int> totList = [totBeer, totCocktails, totSuper, totWine];

      return _weekDrinks(context, totList);
    } else {
      return Text("DB Empty");
    }
  }

  Widget _weekDrinks(BuildContext context, List<int> totList) {
    List<Widget> cardList = weekDrinkCards(context, totList);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 200,
        child: Card(
          color: Colors.brown[300],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                "You drunk a total of",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: cardList.sublist(0, 2)),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: cardList.sublist(2, 4)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> weekDrinkCards(BuildContext context, List<int> totList) {
    return List.generate(
      4,
      (idx) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 12,
          child: Card(
            color: Colors.brown[200],
            child: Center(
              child: ListTile(
                dense: true,
                title: Text(
                  totList[idx].toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      },
    );
  }

  Widget _moneyKcal(BuildContext context, Map<dynamic, dynamic> alcMap) {
    double totSpent = 0;
    double totCal = 0;
    for (int i = 0; i < weekDay; i++) {
      if (alcMap[thisWeek[i]] != null) {
        totSpent += alcMap[thisWeek[i]]["TotalSpent"];
        totCal += alcMap[thisWeek[i]]['TotalCal'];
      } else {
        totSpent += 0;
        totCal += 0;
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Colors.brown[300],
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 25) / 2,
              height: 150,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "You spent",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Card(
                          color: Colors.brown[200],
                          child: Center(
                            child: Text(
                              "$totSpent€",
                              style: TextStyle(fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.brown[300],
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 25) / 2,
              height: 150,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "You introduced",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Card(
                          color: Colors.brown[200],
                          child: Center(
                            child: Text(
                              "${totCal.toInt()} Kcal",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sleep(BuildContext context, Map<String, SleepDay> sleepMap) {
    //elaborazione
    double totQuality = 0;
    double totEfficiency = 0;
    double totLatency = 0;
    double totWaso = 0;
    double totDuration = 0;
    double totLightPhase = 0;
    double totDeepPhase = 0;
    double totRemPhase = 0;
    double totEfficiencyScore = 0;
    double totLatencyScore = 0;
    double totWasoScore = 0;
    double totDurationScore = 0;
    for (int i = 0; i < weekDay; i++) {
      SleepFunction? day = SleepFunction.fromSleepDay(sleepMap[thisWeek[i]]!);
      totQuality += day.SleepQualityDS()!;
      totEfficiency += day.SleepEfficiency()![0];
      totLatency += day.SleepLatency()![0];
      totWaso += day.WASO()![0];
      totDuration += day.SleepDuration()![0];
      totLightPhase += day.SleepPhases()![0];
      totDeepPhase += day.SleepPhases()![1];
      totRemPhase += day.SleepPhases()![2];
      totEfficiencyScore += day.SleepEfficiency()![1];
      totLatencyScore += day.SleepLatency()![1];
      totWasoScore += day.WASO()![1];
      totDurationScore += day.SleepDuration()![1];
      day = null;
    }
    double meanTotQuality = totQuality / weekDay;
    double meanTotEfficiency = totEfficiency / weekDay;
    double meanTotLatency = totLatency / weekDay;
    double meanTotWaso = totWaso / weekDay;
    double meanTotDuration = totDuration / weekDay;
    double meanTotLightPhase = totLightPhase / weekDay;
    double meanTotDeepPhase = totDeepPhase / weekDay;
    double meanTotRemPhase = totRemPhase / weekDay;
    double meanTotEfficiencyScore = totEfficiencyScore / weekDay;
    double meanTotLatencyScore = totLatencyScore / weekDay;
    double meanTotWasoScore = totWasoScore / weekDay;
    double meanTotDurationScore = totDurationScore / weekDay;

    IconData _getIconForQuality(double meanTotQuality) {
      if (meanTotQuality > 80) {
        return Icons.sentiment_very_satisfied;
      } else if (meanTotQuality > 60) {
        return Icons.sentiment_satisfied;
      } else if (meanTotQuality > 40) {
        return Icons.sentiment_dissatisfied;
      } else {
        return Icons.sentiment_very_dissatisfied;
      }
    }

    Color? _getColorForQuality(double meanTotQuality) {
      if (meanTotQuality > 80) {
        return Colors.blueAccent[400];
      } else if (meanTotQuality > 60) {
        return Colors.greenAccent[400];
      } else if (meanTotQuality > 40) {
        return Colors.yellowAccent[400];
      } else {
        return Colors.redAccent[400];
      }
    }

    String _getTextForQuality(double meanTotQuality) {
      if (meanTotQuality > 80) {
        return 'Excellent Sleep Quality';
      } else if (meanTotQuality > 60) {
        return 'Good Sleep Quality';
      } else if (meanTotQuality > 40) {
        return 'Bad Sleep Quality';
      } else {
        return 'Very Bad Sleep Quality';
      }
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 250,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Expanded(
                child: Card(
                  color: Colors.brown[300],
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'Sleep Quality',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.brown[200],
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SimpleCircularProgressBar(
                                    valueNotifier:
                                        ValueNotifier(meanTotQuality),
                                    size: 120,
                                    backStrokeWidth: 20,
                                    progressStrokeWidth: 20,
                                    animationDuration: 1,
                                    mergeMode: true,
                                    progressColors: const [
                                      Colors.redAccent,
                                      Colors.orangeAccent,
                                      Colors.amberAccent,
                                      Colors.greenAccent,
                                      Colors.blueAccent,
                                    ],
                                    backColor: Colors.transparent,
                                    onGetText: (double meanTotQuality) {
                                      TextStyle centerTextStyle = TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: meanTotQuality > 80
                                            ? Colors.blueAccent[400]
                                            : meanTotQuality > 60
                                                ? Colors.greenAccent[400]
                                                : meanTotQuality > 40
                                                    ? Colors.yellowAccent[400]
                                                    : Colors.redAccent[400],
                                      );
                                      return Text(
                                        '${meanTotQuality.toInt()}',
                                        style: centerTextStyle,
                                      );
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getIconForQuality(meanTotQuality),
                                        size: 50,
                                        color:
                                            _getColorForQuality(meanTotQuality),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        _getTextForQuality(meanTotQuality),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.brown[300],
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Efficiency',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.brown[200],
                                child: SimpleCircularProgressBar(
                                  size: 100,
                                  backStrokeWidth: 15,
                                  progressStrokeWidth: 15,
                                  animationDuration: 0,
                                  valueNotifier:
                                      ValueNotifier(meanTotEfficiency),
                                  mergeMode: true,
                                  progressColors: const [
                                    Colors.redAccent,
                                    Colors.orangeAccent,
                                    Colors.amberAccent,
                                    Colors.greenAccent,
                                    Colors.blueAccent,
                                  ],
                                  backColor: Colors.transparent,
                                  onGetText: (double meanTotEfficiency) {
                                    TextStyle centerTextStyle = TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: meanTotEfficiencyScore > 80
                                          ? Colors.blueAccent[400]
                                          : meanTotEfficiencyScore > 60
                                              ? Colors.greenAccent[400]
                                              : meanTotEfficiencyScore > 40
                                                  ? Colors.yellowAccent[400]
                                                  : Colors.redAccent[400],
                                    );
                                    return Text(
                                      '${meanTotEfficiency.toInt()}%',
                                      style: centerTextStyle,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.brown[900],
                      child: Container(
                        color: Colors.brown[300],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "Sleep's Phases",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Card(
                                  color: Colors.brown[200],
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                  value: meanTotLightPhase,
                                                  color: Colors.blue[100],
                                                  title:
                                                      'Light\n${(meanTotLightPhase * 10).truncateToDouble() / 10}%',
                                                  radius: 50,
                                                  showTitle: true,
                                                  titleStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              PieChartSectionData(
                                                value: meanTotDeepPhase,
                                                color: Colors.blue[0],
                                                title:
                                                    'Deep\n${(meanTotDeepPhase * 10).truncateToDouble() / 10}%',
                                                radius: 50,
                                                showTitle: true,
                                                titleStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              PieChartSectionData(
                                                  value: meanTotRemPhase,
                                                  color: Colors.blue[500],
                                                  title:
                                                      'REM\n${(meanTotRemPhase * 10 + 1).truncateToDouble() / 10}%',
                                                  radius: 50,
                                                  showTitle: true,
                                                  titleStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.width) / 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.brown[300],
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Duration",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Card(
                                color: Colors.brown[200],
                                child: Center(
                                  child: Text(
                                    "${(meanTotDuration * 10).truncateToDouble() / 10} h",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: meanTotDurationScore > 80
                                          ? Colors.blueAccent[400]
                                          : meanTotDurationScore > 60
                                              ? Colors.greenAccent[400]
                                              : meanTotDurationScore > 40
                                                  ? Colors.yellowAccent[400]
                                                  : Colors.redAccent[400],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.brown[300],
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Latency",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Card(
                                color: Colors.brown[200],
                                child: Center(
                                  child: Text(
                                    "$meanTotLatency min",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: meanTotLatencyScore > 80
                                          ? Colors.blueAccent[400]
                                          : meanTotLatencyScore > 60
                                              ? Colors.greenAccent[400]
                                              : meanTotLatencyScore > 40
                                                  ? Colors.yellowAccent[400]
                                                  : Colors.redAccent[400],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.brown[300],
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "WASO",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Card(
                                color: Colors.brown[200],
                                child: Center(
                                  child: Text(
                                    "${meanTotWaso.toInt()} min",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: meanTotWasoScore > 80
                                          ? Colors.blueAccent[400]
                                          : meanTotWasoScore > 60
                                              ? Colors.greenAccent[400]
                                              : meanTotWasoScore > 40
                                                  ? Colors.yellowAccent[400]
                                                  : Colors.redAccent[400],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

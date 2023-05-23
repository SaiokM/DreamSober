import 'package:dreamsober/bar_graph/individual_bar.dart';
import 'dart:developer';

class BarData {
  final List<String> dayList;
  final List<dynamic> alcList;
  final List<dynamic> sleepList;
  final List<dynamic> moneyList;

  BarData({
    required this.dayList,
    required this.alcList,
    required this.sleepList,
    required this.moneyList,
  });

  List<IndividualBar> barData = [];
  void initializeBarData() {
    for (int i = 0; i < dayList.length; i++) {
      barData.add(IndividualBar(
        x: i,
        y1: alcList[i],
        y2: sleepList[i],
        y3: moneyList[i],
      ));
    }
  }

  void resetBarData() {
    barData = [];
  }
}

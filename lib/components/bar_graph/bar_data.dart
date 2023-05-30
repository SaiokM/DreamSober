import 'package:dreamsober/components/bar_graph/individual_bar.dart';
import 'dart:developer';

class BarData {
  final List<String> dayList;
  final List<double> alcList;
  final List<double> sleepList;
  final List<double> moneyList;
  final List<double> slpqltList;

  BarData({
    required this.dayList,
    required this.alcList,
    required this.sleepList,
    required this.moneyList,
    required this.slpqltList,
  });

  List<IndividualBar> barData = [];
  void initializeBarData() {
    for (int i = 0; i < dayList.length; i++) {
      barData.add(IndividualBar(
        x: i,
        y1: alcList[i],
        y2: sleepList[i],
        y3: moneyList[i],
        y4: slpqltList[i],
      ));
    }
  }

  void resetBarData() {
    barData = [];
  }
}

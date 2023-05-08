import 'package:dreamsober/bar_graph/individual_bar.dart';
import 'dart:developer';

class BarData {
  final List<String> dayList;
  final List<dynamic> alcList;
  final List<dynamic> sleepList;

  BarData({
    required this.dayList,
    required this.alcList,
    required this.sleepList,
  });

  List<IndividualBar> barData = [];
  void initializeBarData() {
    for (int i = 0; i < dayList.length - 1; i++) {
      barData.add(IndividualBar(
        x: i,
        y1: alcList[i],
        y2: sleepList[i],
      ));
    }
  }

  void resetBarData() {
    barData = [];
  }
}

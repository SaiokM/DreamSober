import 'package:dreamsober/models/sleepphase.dart';

class SleepDay {
  late String date;
  late double duration; //seconds
  late int minToFall;
  late int minAsleep;
  late int minAwake;
  Map<String, SleepPhase> phases = {};
  List<String> phasesName = ['wake', 'light', 'deep', 'rem'];

  SleepDay.fromJson(Map<dynamic, dynamic> json) {
    date = json['date'];
    if (json['data'] != null && json['data'].runtimeType != List) {
      //print(json['data'].runtimeType);
      duration = json['data']['duration'].toDouble() / 1000 ?? 0;
      minToFall = json['data']['minutesToFallAsleep'] ?? 0;
      minAsleep = json['data']['minutesAsleep'] ?? 0;
      minAwake = json['data']['minutesAwake'] ?? 0;
      for (String phase in phasesName) {
        SleepPhase slpphase = SleepPhase(
          json['data']['levels']['summary'][phase]['count'] ?? 0,
          json['data']['levels']['summary'][phase]['minutes'] ?? 0,
        );
        phases[phase] = slpphase;
      }
    } else {
      duration = 0;
      minToFall = 0;
      minAsleep = 0;
      minAwake = 0;
      for (String phase in phasesName) {
        SleepPhase slpphase = SleepPhase(0, 0);
        phases[phase] = slpphase;
      }
    }
  }
}

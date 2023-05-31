class SleepDay {
  late String date;
  late double? duration; //seconds
  late int? minToFall;
  late int? minAsleep;
  late int? minAwake;
  bool emptyDay = false;

  Map<String, SleepPhase> phases = {};
  List<String> phasesName = ['wake', 'light', 'deep', 'rem'];

  SleepDay.fromJson(Map<dynamic, dynamic> json) {
    date = json['date'];
    if (json['data'] != null && json['data'].runtimeType != List) {
      duration = json['data']['duration'].toDouble() / 1000;
      minToFall = json['data']['minutesToFallAsleep'];
      minAsleep = json['data']['minutesAsleep'];
      minAwake = json['data']['minutesAwake'];
      for (String phase in phasesName) {
        SleepPhase slpphase = SleepPhase(
          json['data']['levels']['summary'][phase]['count'],
          json['data']['levels']['summary'][phase]['minutes'],
        );
        phases[phase] = slpphase;
      }
      if (duration == null) {
        emptyDay = true;
      }
    } else {
      emptyDay = true;
      duration = null;
      minToFall = null;
      minAsleep = null;
      minAwake = null;
      for (String phase in phasesName) {
        SleepPhase slpphase = SleepPhase(null, null);
        phases[phase] = slpphase;
      }
    }
  }
}

class SleepPhase {
  final int? _count;
  final int? _minutes;
  SleepPhase(this._count, this._minutes);
  int? get count => _count;
  int? get min => _minutes;
}

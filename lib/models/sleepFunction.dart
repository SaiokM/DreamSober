import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:flutter/material.dart';

class SleepFunction {
  late final int _age;
  late final int _timeAsleep;
  late final double _sleepDuration;
  late final int _timeToFallAsleep;
  late final int _timeAwake;
  late final double _sleepEfficiencyScore;
  late final double _sleepLatencyScore;
  late final double _sleepDurationScore;
  late final num _wasoScore;
  late final double _phaseScores;
  late final double _lightScore;
  late final double _deepScore;
  late final double _remScore;
  late final int _lightDuration;
  late final int _deepDuration;
  late final int _remDuration;
  late final double _sleepQualityScore;

  void addAge(int age) => _age = age;
  SleepFunction.fromSleepDay(SleepDay day) {
    _timeAsleep = day.minAsleep;
    _sleepDuration = day.duration;
    _timeToFallAsleep = day.minToFall;
    _timeAwake = day.minAwake;
    _lightDuration = day.phases['light']!.min;
    _deepDuration = day.phases['deep']!.min;
    _remDuration = day.phases['rem']!.min;
  }

  //Sleep Effinciency (SE) = time asleep/total time in bed
  List <double>? SleepEfficiency() {
    double sleepEfficiency = (_timeAsleep * 60 / _sleepDuration) * 100; //%
    if (_age >= 25) {
      //adult
      if (sleepEfficiency >= 85) {
        _sleepEfficiencyScore = 100; //good, at least 85%
      } else if (sleepEfficiency >= 74) {
        _sleepEfficiencyScore = (sleepEfficiency - 74) * (100 / 11);
      } else {
        _sleepEfficiencyScore = 0; //poor, lesser than 74%
      }
    } else {
      //young adult
      if (sleepEfficiency >= 85) {
        _sleepEfficiencyScore = 100; //good, al least 85%
      } else if (sleepEfficiency >= 64) {
        _sleepEfficiencyScore = (sleepEfficiency - 64) * (100 / 11);
      } else {
        _sleepEfficiencyScore = 0; //poor, lesser than 74%
      }
    }
    return [sleepEfficiency, _sleepEfficiencyScore];
  }

//Sleep Latency= time wakefulness to slepp [min]
  List <double>? SleepLatency() {
    if (_timeToFallAsleep <= 30) {
      _sleepLatencyScore = 100; //good, lesser than 30 min
    } else if (_timeToFallAsleep <= 60) {
      _sleepLatencyScore = (60 - _timeToFallAsleep) * (100 / 30);
    } else {
      _sleepLatencyScore = 0; //poor, bigger than 60min
    }
    return [_timeToFallAsleep.toDouble(), _sleepLatencyScore];
  }

// duration [min]: 
  List <double>? SleepDuration() {
    _sleepDuration = _sleepDuration / 3600; //min -> hours
    if (_sleepDuration >= 7 && _age >= 18) {
      //Adults, at least 7 hours
      _sleepDurationScore = 100; //good
    } else if (_sleepDuration >= 8 && _age < 18) {
      //Young, at least 8 hours
      _sleepDurationScore = 100; //good
    } else {
      _sleepDurationScore = 0; //poor
    }
    return [_sleepDuration, _sleepDurationScore];
  }

//WASO: Wake After Sleep Onset [min]
  List<double>? WASO() {
    if (_timeAwake <= 20) {
      _wasoScore = 100; //good, lesser than 20min
    } else if (_timeAwake <= 51) {
      _wasoScore = (100 - (_timeAwake - 20) * (100 / 31));
    } else {
      _wasoScore = 0; //poor, bigger than 51 min
    }
    return [_timeAwake.toDouble(), _wasoScore.toDouble()];
  }

//Sleep Phase: Light 60%, Deep 15%, REM 25% od the total sleep duration
  List? SleepPhases() {
    double totalSleepDuration =
        (_lightDuration + _deepDuration + _remDuration).toDouble();
    _lightScore = (_lightDuration / totalSleepDuration) * 100;
    _deepScore = (_deepDuration / totalSleepDuration) * 100;
    _remScore = (_remDuration / totalSleepDuration) * 100;
    _phaseScores = (_lightScore - 60).abs() +
        (_deepScore - 15).abs() +
        (_remScore - 25)
            .abs(); //Sum of the differences between the sleep phases percentage scores and the desired baseline
    _phaseScores = 100 - _phaseScores;
    List _phases = [_lightScore, _deepScore, _remScore];
    return _phases;
  }

  double? SleepQualityDS() {
    (_sleepEfficiencyScore +
            _sleepLatencyScore +
            _sleepDurationScore +
            _wasoScore +
            _phaseScores) /
        5;
    return _sleepQualityScore;
  }
}

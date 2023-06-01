import 'dart:developer';

import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:flutter/material.dart';

class SleepFunction {
  final int _age = UserPrefs.getAge();
  int _timeAsleep = 0;
  double _sleepDuration = 0;
  int _timeToFallAsleep = 0;
  int _timeAwake = 0;
  double _sleepEfficiencyScore = 0;
  double _sleepLatencyScore = 0;
  double _sleepDurationScore = 0;
  num _wasoScore = 0;
  double _phaseScores = 0;
  double _lightScore = 0;
  double _deepScore = 0;
  double _remScore = 0;
  int _lightDuration = 0;
  int _deepDuration = 0;
  int _remDuration = 0;
  double _sleepQualityScore = 0;

  SleepFunction.fromSleepDay(SleepDay day) {
    _timeAsleep = day.minAsleep;
    _sleepDuration = day.duration / 3600; //sec -> hours
    _timeToFallAsleep = day.minToFall;
    _timeAwake = day.minAwake;
    _lightDuration = day.phases['light']!.min;
    _deepDuration = day.phases['deep']!.min;
    _remDuration = day.phases['rem']!.min;
    SleepEfficiency();
    SleepLatency();
    SleepDuration();
    WASO();
    SleepPhases();
    SleepQualityDS();
  }

  //Sleep Effinciency (SE) = time asleep/total time in bed
  List<double>? SleepEfficiency() {
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
    if (_sleepEfficiencyScore.isNaN) {
      _sleepEfficiencyScore = 0;
    }
    if (sleepEfficiency.isNaN) {
      sleepEfficiency = 0;
    }
    return [sleepEfficiency, _sleepEfficiencyScore];
  }

//Sleep Latency= time wakefulness to slepp [min]
  List<double>? SleepLatency() {
    if (_timeToFallAsleep <= 30) {
      _sleepLatencyScore = 100; //good, lesser than 30 min
    } else if (_timeToFallAsleep <= 60) {
      _sleepLatencyScore = (60 - _timeToFallAsleep) * (100 / 30);
    } else {
      _sleepLatencyScore = 0; //poor, bigger than 60min
    }
    if (_sleepLatencyScore.isNaN) {
      _sleepLatencyScore = 0;
    }
    if (_timeToFallAsleep.isNaN) {
      _timeToFallAsleep = 0;
    }
    return [_timeToFallAsleep.toDouble(), _sleepLatencyScore];
  }

// duration [min]:
  List<double>? SleepDuration() {
    if (_sleepDuration >= 7 && _age >= 18) {
      //Adults, at least 7 hours
      _sleepDurationScore = 100; //good
    } else if (_sleepDuration >= 8 && _age < 18) {
      //Young, at least 8 hours
      _sleepDurationScore = 100; //good
    } else {
      _sleepDurationScore = 0; //poor
    }
    if (_sleepDurationScore.isNaN) {
      _sleepDurationScore = 0;
    }
    if (_sleepDuration.isNaN) {
      _sleepDuration = 0;
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
    if (_wasoScore.isNaN) {
      _wasoScore = 0;
    }
    if (_timeAwake.isNaN) {
      _timeAwake = 0;
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
    if (_phaseScores.isNaN) {
      _phaseScores = 0;
    }
    if (_lightScore.isNaN) {
      _lightScore = 0;
    }
    if (_deepScore.isNaN) {
      _deepScore = 0;
    }
    if (_remScore.isNaN) {
      _remScore = 0;
    }
    return [_lightScore, _deepScore, _remScore, _phaseScores];
  }

  double? SleepQualityDS() {
    //log("-----------------\n$_sleepEfficiencyScore\n$_sleepLatencyScore\n$_sleepDurationScore\n$_wasoScore\n$_phaseScores\n----------------------");

    _sleepQualityScore = (_sleepEfficiencyScore +
            _sleepLatencyScore +
            _sleepDurationScore +
            _wasoScore +
            _phaseScores) /
        5;
    _sleepQualityScore = (_sleepQualityScore * 100).truncateToDouble() / 100;
    if (_sleepQualityScore.isNaN) {
      _sleepQualityScore = 0;
    }
    return _sleepQualityScore;
  }
}

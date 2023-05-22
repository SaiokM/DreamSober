import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:flutter/material.dart';

class SleepFunction {
  late final int _age;
  late final _timeAsleep;
  late final _sleepDuration;
  late final _timeToFallAsleep;
  late final _timeAwake;
  late final double _sleepEfficiencyScore;
  late final double _sleepLatencyScore;
  late final double _sleepDurationScore;
  late final num _wasoScore;
  late final double _phaseScores;
  late final double _lightScore;
  late final double _deepScore;
  late final double _remScore;
  late final  _lightDuration;
  late final  _deepDuration;
  late final  _remDuration;
  late final double _sleepQualityScore;

  void addAge(int age) => _age = age;
  void fromSleepDay(SleepDay day){
    _timeAsleep = day.minAsleep;
    _sleepDuration=day.duration;
    _timeToFallAsleep=day.minToFall;
    _timeAwake=day.minAwake;
    _lightDuration=day.phases['light'];
    _deepDuration=day.phases['deep'];
    _remDuration=day.phases['rem'];
  }

 //Sleep Effinciency (SE) = time asleep/total time in bed 
  double? SleepEfficiency(){
    int sleepEfficiency = (_timeAsleep*60/_sleepDuration)*100; //%
    if (_age >= 25){  //adult
      if (sleepEfficiency >= 85) {
        _sleepEfficiencyScore = 100; //good 
    } else if (sleepEfficiency >= 74) {
        _sleepEfficiencyScore = (sleepEfficiency - 74) * (100 / 11); 
    } else {
        _sleepEfficiencyScore = 0; //poor
    }
    }else{  //young adult
      if (sleepEfficiency >= 85) {
        _sleepEfficiencyScore = 100; //good 
    } else if (sleepEfficiency >= 64) {
        _sleepEfficiencyScore = (sleepEfficiency - 64) * (100 / 11);
    } else {
        _sleepEfficiencyScore = 0; //poor 
    }
    }
    return _sleepEfficiencyScore;
  }

//Sleep Latency= time wakefulness-slepp [min]
  double? SleepLatency(){
    if (_timeToFallAsleep <= 30) {
      _sleepLatencyScore = 100;  //good
    } else if (_timeToFallAsleep <= 60) {
      _sleepLatencyScore = (60 - _timeToFallAsleep) * (100 / 30);
    } else {
      _sleepLatencyScore = 0;  //poor
    }
    return _sleepLatencyScore;
  }

// duration [min]
  double? SleepDuration(){
    if (_sleepDuration >= 7 && _age >= 18) {  //Adults
      _sleepDurationScore = 100; //good
    } else if (_sleepDuration >= 8 && _age < 18){ //Young 
      _sleepDurationScore = 100; //good
    }else {
      _sleepDurationScore = 0; //poor
    }
    return _sleepDurationScore;
  }

//WASO: Wake After Sleep Onset [min]
  num? WASO(){
    if (_timeAwake <= 20) {
      _wasoScore = 100;  //good
    } else if (_timeAwake <= 51) {
      _wasoScore = (100 - (_timeAwake - 20) * (100 / 31));
    } else {
      _wasoScore = 0; //poor
    }
    return _wasoScore;
  }

//Sleep Phase: Light 60%, Deep 15%, REM 25% od the total sleep duration
  double? SleepPhases(){
    double totalSleepDuration = _lightDuration + _deepDuration + _remDuration;
    _lightScore = (_lightDuration / totalSleepDuration) * 100;
    _deepScore = (_deepDuration / totalSleepDuration) * 100;
    _remScore = (_remDuration / totalSleepDuration) * 100;
    _phaseScores = (_lightScore - 60).abs() + (_deepScore - 15).abs() + (_remScore - 25).abs(); //Sum of the differences between the sleep phases percentage scores and the desired baseline
    _phaseScores = 100 - _phaseScores;
    return _phaseScores;
  }

  double? SleepQualityDS(){
    (_sleepEfficiencyScore + _sleepLatencyScore + _sleepDurationScore + _wasoScore + _phaseScores) / 5;
    return _sleepQualityScore;
  }

}
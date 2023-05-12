import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/models/drink.dart';

class DailyDrinkDB with ChangeNotifier {
  final Map<String, int> _drinkList = {
    'Beer': 0,
    'Cocktail': 0,
    'Wine': 0,
    'Super Alcoholics': 0
  };

  final List<Drink> drinks = [
    Drink('Beer', 4, 500, 5),
    Drink('Cocktail', 8, 200, 8),
    Drink('Super Alcoholics', 40, 40, 6),
    Drink('Wine', 12, 150, 4)
  ];
  DateTime _date = DateTime.now();
  double _sleepScore = 0;
  double _totAlc = 0;

  Map<String, int> get drinkList => _drinkList;
  double get total => _totAlc;
  DateTime get date => _date;
  double get sleep => _sleepScore;

  bool _modify = true;

  bool get modify => _modify;
  void mod(bool m) {
    _modify = m;
    notifyListeners();
  }

  void loadFromJson(Map<dynamic, dynamic> json) {
    _date = DateTime.parse(json['Date']);
    _drinkList.update('Beer', (value) => json['Drinks']['Beer']);
    _drinkList.update('Cocktail', (value) => json['Drinks']['Cocktail']);
    _drinkList.update(
        'Super Alcoholics', (value) => json['Drinks']['Super Alcoholics']);
    drinkList.update('Wine', (value) => json['Drinks']['Wine']);
    _totAlc = json['TotalAlcohol'].toDouble();
    _sleepScore = json['SleepScore'].toDouble();
  }

  void addDate(DateTime newDate) {
    _date = newDate;
    //print(_date);
    notifyListeners();
  }

  void addDrink(String name, int number) {
    if (_drinkList.containsKey(name)) {
      _drinkList.update(name, (value) => _drinkList[name]! + number);
    }
    notifyListeners();
  }

  void removeDrink(String name, int number) {
    if (_drinkList.containsKey(name)) {
      _drinkList.update(name, (value) => _drinkList[name]! - number);
      if (drinkList[name]! < 0) {
        _drinkList.update(name, (value) => 0);
      }
    }
    notifyListeners();
  }

  int? getDrinkCount(String drinkname) {
    if (_drinkList.containsKey(drinkname)) {
      return _drinkList[drinkname];
    }
    return null;
  }

  void resetDB() {
    for (String key in _drinkList.keys) {
      _drinkList.update(key, (value) => 0);
    }
    notifyListeners();
  }

  void totalAlcohol() {
    _totAlc = 0;
    for (Drink drink in drinks) {
      if (_drinkList.containsKey(drink.name)) {
        _totAlc +=
            (drink.perc / 100) * (drink.volume) * getDrinkCount(drink.name)!;
      } else {
        _totAlc += 0;
      }
      //print(drink.name);
    }
    notifyListeners();
    //print(sum);
  }

  Future<void> saveDay(DatabaseReference dbRef) async {
    String dateName = _date.toString().split(' ')[0];
    //print(dateName);
    totalAlcohol();
    dbRef.child(dateName).set(
      {
        "Drinks": {
          "Beer": _drinkList["Beer"],
          "Cocktail": _drinkList["Cocktail"],
          "Wine": _drinkList["Wine"],
          "Super Alcoholics": _drinkList["Super Alcoholics"],
        },
        "Date": _date.toString(),
        "TotalAlcohol": _totAlc,
        "SleepScore": _sleepScore,
      },
    );
  }

  Future<void> removeDay(DatabaseReference dbRef, String date) async {
    if (date == "") {
      date = _date.toString().split(' ')[0];
      dbRef.child(date).remove();
    } else {
      dbRef.child(date).remove();
    }
    resetDB();
  }

  void notifyChange() {
    notifyListeners();
  }
}

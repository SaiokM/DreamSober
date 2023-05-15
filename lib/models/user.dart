import 'package:firebase_database/firebase_database.dart';

class CurrentUser {
  final String _name;
  final int _age;
  final double _height;
  final double _weight;
  final dynamic _sex;

  CurrentUser(
    this._name,
    this._age,
    this._height,
    this._weight,
    this._sex,
  );

  factory CurrentUser.fromJson(Map<dynamic, dynamic> json) {
    final name = json["name"];
    final age = json["age"];
    final height = json["height"].toDouble();
    final weight = json["weight"].toDouble();
    final sex = json["sex"];
    return CurrentUser(name, age, height, weight, sex);
  }

  String get name => _name;
  int get age => _age;
  double get height => _height;
  double get weight => _weight;
  dynamic get sex => _sex;

  void saveToDB(DatabaseReference dbRef) {
    dbRef.set({
      "name": _name,
      "age": _age,
      "height": _height,
      "weight": _weight,
      "sex": sex,
    });
  }
}

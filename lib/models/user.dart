class User {
  final String _name;
  final String _surname;
  final int _age;
  final double _height;
  final double _weight;
  final dynamic _sex;

  User(
    this._name,
    this._surname,
    this._age,
    this._height,
    this._weight,
    this._sex,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json["name"];
    final surname = json["surname"];
    final age = json["age"];
    final height = json["height"];
    final weight = json["weight"];
    final sex = json["sex"];
    return User(name, surname, age, height, weight, sex);
  }

  String get name => _name;
  String get surname => _surname;
  int get age => _age;
  double get height => _height;
  double get weight => _weight;
  dynamic get sex => _sex;
}

class Drink {
  final String _name;
  final double _alchPerc;
  final double _volume; //in ml
  final double _price;
  late double _kcal;
  Drink(this._name, this._alchPerc, this._volume, this._price);
  String get name => _name;
  double get perc => _alchPerc;
  double get volume => _volume;
  double get kcal => _kcal;
  double get price => _price;

  void calKcal() {
    _kcal = (_alchPerc / 100 * _volume * 5.53 * 100).truncateToDouble() / 100;
  }
}

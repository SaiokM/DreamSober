class Drink {
  final String _name;
  final double _alchPerc;
  final double _volume; //in ml
  final double _price;
  late final double _kcal;
  Drink(this._name, this._alchPerc, this._volume, this._price);
  String get name => _name;
  double get perc => _alchPerc;
  double get volume => _volume;
  double get kcal => _kcal;
  double get price => _price;

  void calcKcal() {
    _kcal = _alchPerc * _volume * 5.53;
  }
}

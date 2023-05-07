class Drink {
  final String _name;
  final double _alchPerc;
  final double _volume; //in ml
  Drink(this._name, this._alchPerc, this._volume);

  String get name => _name;
  double get perc => _alchPerc;
  double get volume => _volume;
}

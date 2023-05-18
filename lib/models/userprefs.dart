import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUID(String userUID) async =>
      await _preferences.setString('userUID', userUID);
  static String getUID() => _preferences.getString('userUID') ?? '';

  static void resetUser() => _preferences.clear();

  static void clearTokens() {
    _preferences.remove('access');
    _preferences.remove('refresh');
  }

  static Future setImpactUsername(String username) async =>
      await _preferences.setString('imapactUsername', username);
  static Future setImpactPsw(String password) async =>
      await _preferences.setString('impactPassword', password);
  static Future setImpactAccess(String access) async =>
      await _preferences.setString('access', access);
  static Future setImpactRefresh(String refresh) async =>
      await _preferences.setString('refresh', refresh);
  static Future setLogin(bool login) => _preferences.setBool('login', login);

  static String getImpactUser() =>
      _preferences.getString('imapactUsername') ?? '';
  static String getImpactPsw() =>
      _preferences.getString('impactPassword') ?? '';
  static String? getImpactAccess() => _preferences.getString('access');
  static String? getImpactRefresh() => _preferences.getString('refresh');
}

import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void resetUser() => _preferences.clear();

  //Firebase
  static Future setUID(String userUID) async =>
      await _preferences.setString('userUID', userUID);
  static Future setFBUsername(String username) async =>
      await _preferences.setString('firebaseUsername', username);
  static Future setFBpsw(String password) async =>
      await _preferences.setString('firebasePassword', password);
  static Future setFBlogin(bool login) =>
      _preferences.setBool('firebaseLogin', login);

  static String getUID() => _preferences.getString('userUID') ?? '';
  static String? getFBUser() => _preferences.getString('firebaseUsername');
  static String? getFBpsw() => _preferences.getString('firebasePassword');
  static bool getFBLogin() => _preferences.getBool('firebaseLogin') ?? false;

  //Impact
  static Future setImpactUsername(String username) async =>
      await _preferences.setString('impactUsername', username);
  static Future setImpactPsw(String password) async =>
      await _preferences.setString('impactPassword', password);
  static Future setImpactAccess(String access) async =>
      await _preferences.setString('access', access);
  static Future setImpactRefresh(String refresh) async =>
      await _preferences.setString('refresh', refresh);
  static Future setImpactLogin(bool login) =>
      _preferences.setBool('impactLogin', login);

  static void clearTokens() {
    _preferences.remove('access');
    _preferences.remove('refresh');
  }

  static String getImpactUser() =>
      _preferences.getString('impactUsername') ?? '';
  static String getImpactPsw() =>
      _preferences.getString('impactPassword') ?? '';
  static String? getImpactAccess() => _preferences.getString('access');
  static String? getImpactRefresh() => _preferences.getString('refresh');
  static bool getImpactLogin() => _preferences.getBool('impactLogin') ?? false;
}

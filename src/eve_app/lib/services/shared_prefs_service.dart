import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  bool _isInitialized = false;
  late SharedPreferences _sharedPreferences;
  SharedPrefsService._privateConstructor();

  static final SharedPrefsService _instance = SharedPrefsService._privateConstructor();

  factory SharedPrefsService() {
    return _instance;
  }

  SharedPreferences? get getSharedPrefs => _sharedPreferences;

  Future<void> initSharedPrefsService({bool forceInit = false}) async {
    if (!_isInitialized || forceInit) {
      _sharedPreferences = await SharedPreferences.getInstance();
      setSharedPrefBool("shared_preferences_initialised", true);
      _isInitialized = true;
    }
  }

  void setSharedPref(String key, String value) {
    _sharedPreferences.setString(key, value);
  }

  String? getSharedPref(String key) {
    return _sharedPreferences.getString(key);
  }

  void setSharedPrefInt(String key, int value) {
    _sharedPreferences.setInt(key, value);
  }

  int? getSharedPrefInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  void setSharedPrefDouble(String key, double value) {
    _sharedPreferences.setDouble(key, value);
  }

  double? getSharedPrefDouble(String key) {
    return _sharedPreferences.getDouble(key);
  }

  void setSharedPrefBool(String key, bool value) {
    _sharedPreferences.setBool(key, value);
  }

  bool? getSharedPrefBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  void setSharedPrefStringList(String key, List<String>? stringList) {
    if (stringList == null) {
      _sharedPreferences.remove(key);
    } else {
      _sharedPreferences.setStringList(key, stringList);
    }
  }

  List<String>? getSharedPrefStringList(String key) {
    return _sharedPreferences.getStringList(key);
  }

  void removeSharedPrefByKey(String key) {
    _sharedPreferences.remove(key);
  }

  //add more if needed, setInt etc
}

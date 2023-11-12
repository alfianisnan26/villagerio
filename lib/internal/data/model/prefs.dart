import 'package:shared_preferences/shared_preferences.dart';

class Prefs<T extends String> {
  Type get _classType => T;
  late String _key;
  final T _defaultValue;

  Prefs(String key, this._defaultValue) {
    this._key = "villagerio:prefs:key:$key";
  }

  Future<T> get() async {
    final prefs = await SharedPreferences.getInstance();
    switch (_classType) {
      case String:
        return prefs.getString(_key) as T? ?? this._defaultValue;
      case bool:
        return prefs.getBool(_key) as T? ?? this._defaultValue;
      case int:
        return prefs.getInt(_key) as T? ?? this._defaultValue;
      case double:
        return prefs.getDouble(_key) as T? ?? this._defaultValue;
      case const (List<String>):
        return prefs.getStringList(_key) as T? ?? this._defaultValue;
      default:
        throw "Invalid type on mapping shared preferences";
    }
  }

  Future<bool> set(T val) async {
    final prefs = await SharedPreferences.getInstance();
    switch (_classType) {
      case String:
        return prefs.setString(_key, val);
      case bool:
        return prefs.setBool(_key, val as bool);
      case int:
        return prefs.setInt(_key, val as int);
      case double:
        return prefs.setDouble(_key, val as double);
      case const (List<String>):
        return prefs.setStringList(_key, val as List<String>);
      default:
        throw "Invalid type on mapping shared preferences";
    }
  }
}

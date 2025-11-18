import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String sessionKey = 'username_session';
  String? username;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final sp = await SharedPreferences.getInstance();
    username = sp.getString(sessionKey);
    notifyListeners();
  }

  Future<bool> register(String username, String password) async {
    final box = await Hive.openBox('users');
    if (box.containsKey(username)) return false;
    await box.put(username, password);
    return true;
  }

  Future<bool> login(String username, String password, {bool remember = true}) async {
    final box = await Hive.openBox('users');
    if (!box.containsKey(username)) return false;
    final stored = box.get(username);
    if (stored == password) {
      if (remember) {
        final sp = await SharedPreferences.getInstance();
        await sp.setString(sessionKey, username);
      }
      this.username = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(sessionKey);
    username = null;
    notifyListeners();
  }
}
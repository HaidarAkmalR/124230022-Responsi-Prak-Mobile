import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  static const cartKey = 'cart_ids';
  List<int> _ids = [];

  CartProvider() {
    _load();
  }

  List<int> get ids => _ids;

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(cartKey);
    if (s != null) {
      final List data = json.decode(s);
      _ids = data.map((e) => e as int).toList();
    }
    notifyListeners();
  }

  Future<void> add(int id) async {
    if (!_ids.contains(id)) {
      _ids.add(id);
      await _save();
      notifyListeners();
    }
  }

  Future<void> remove(int id) async {
    _ids.remove(id);
    await _save();
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(cartKey, json.encode(_ids));
  }
}
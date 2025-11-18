import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const base = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$base/products'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<String>> fetchCategories() async {
    final res = await http.get(Uri.parse('$base/products/categories'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
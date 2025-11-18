import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<Product>>? _futureAll;

  @override
  void initState() {
    super.initState();
    _futureAll = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: FutureBuilder<List<Product>>(
        future: _futureAll,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final all = snap.data!;
          final items = all.where((p) => cart.ids.contains(p.id)).toList();
          if (items.isEmpty) return const Center(child: Text('Keranjang kosong'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final p = items[i];
              return ListTile(
                leading: Image.network(p.image, width: 56, height: 56, fit: BoxFit.contain),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(product: p))),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => cart.remove(p.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final inCart = cart.ids.contains(product.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.image, height: 250, fit: BoxFit.contain),
            const SizedBox(height: 12),
            Text(product.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text(product.description),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
              label: Text(inCart ? 'Remove from Cart' : 'Add to Cart'),
              onPressed: () => cart.toggle(product.id),
            )
          ],
        ),
      ),
    );
  }
}
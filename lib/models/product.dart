class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    final r = j['rating'] ?? {};
    return Product(
      id: j['id'],
      title: j['title'],
      price: (j['price'] as num).toDouble(),
      description: j['description'],
      category: j['category'],
      image: j['image'],
      rating: ((r['rate'] ?? 0) as num).toDouble(),
      ratingCount: (r['count'] ?? 0) as int,
    );
  }
}
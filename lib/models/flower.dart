class Flower {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final bool inStock;

  Flower({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    this.inStock = true,
  });

  // Convert Firestore Document to Flower object
  factory Flower.fromFirestore(Map<String, dynamic> data, String docId) {
    return Flower(
      id: docId,
      name: data['name'] ?? 'Unnamed Flower',
      category: data['category'] ?? 'General',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=500',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      inStock: data['inStock'] ?? true,
    );
  }

  // Convert Flower object to Map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'inStock': inStock,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flower.dart';
import '../models/order.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream flowers collection from Firestore in real-time
  Stream<List<Flower>> getFlowersStream({String? category}) {
    Query query = _db.collection('flowers');

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Flower.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Stream orders placed by customer
  Stream<List<FlowerOrder>> getOrdersStream() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FlowerOrder.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Place a new order into Firestore
  Future<String> placeOrder(FlowerOrder order) async {
    DocumentReference ref = await _db.collection('orders').add(order.toFirestore());
    return ref.id;
  }

  // Seed sample flower data for testing
  Future<void> seedInitialData() async {
    final CollectionReference flowersCollection = _db.collection('flowers');
    
    // Check if flowers already exist
    final snapshot = await flowersCollection.get();
    if (snapshot.docs.isNotEmpty) return;

    final sampleFlowers = [
      Flower(
        id: '',
        name: 'Velvet Red Roses Bouquet',
        category: 'Roses',
        price: 49.99,
        description: 'A classic arrangement of 12 premium long-stemmed red roses, handcrafted to convey deep love and elegance.',
        imageUrl: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=800',
        rating: 4.9,
      ),
      Flower(
        id: '',
        name: 'Pastel Sunrise Lilies',
        category: 'Lilies',
        price: 38.50,
        description: 'Fresh pink and white Asiatic lilies bundled with fragrant eucalyptus leaves for a refreshing spring vibe.',
        imageUrl: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=800',
        rating: 4.7,
      ),
      Flower(
        id: '',
        name: 'Royal Purple Orchid Stem',
        category: 'Orchids',
        price: 55.00,
        description: 'Exotic Phalaenopsis orchid presented in an eco-friendly ceramic pot. Long lasting and elegant.',
        imageUrl: 'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?w=800',
        rating: 4.9,
      ),
      Flower(
        id: '',
        name: 'Golden Sunflower Surprise',
        category: 'Sunflowers',
        price: 32.00,
        description: 'Bright and cheerful yellow sunflowers paired with yellow solidago to warm up anyone\'s day.',
        imageUrl: 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?w=800',
        rating: 4.8,
      ),
      Flower(
        id: '',
        name: 'Dutch Soft Pink Tulips',
        category: 'Tulips',
        price: 42.00,
        description: 'Imported fresh Dutch tulips in soft pastel pink tones. Perfect for birthdays and anniversaries.',
        imageUrl: 'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=800',
        rating: 4.6,
      ),
    ];

    for (var flower in sampleFlowers) {
      await flowersCollection.add(flower.toFirestore());
    }
  }
}

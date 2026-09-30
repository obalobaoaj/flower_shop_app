import 'package:flutter/foundation.dart';
import '../models/flower.dart';
import '../models/order.dart';

class CartProvider extends ChangeNotifier {
  final List<OrderItem> _items = [];

  List<OrderItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(Flower flower) {
    int index = _items.indexWhere((item) => item.flowerId == flower.id);
    if (index >= 0) {
      _items[index] = OrderItem(
        flowerId: flower.id,
        flowerName: flower.name,
        price: flower.price,
        quantity: _items[index].quantity + 1,
        imageUrl: flower.imageUrl,
      );
    } else {
      _items.add(
        OrderItem(
          flowerId: flower.id,
          flowerName: flower.name,
          price: flower.price,
          quantity: 1,
          imageUrl: flower.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String flowerId) {
    _items.removeWhere((item) => item.flowerId == flowerId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

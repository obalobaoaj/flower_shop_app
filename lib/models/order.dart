import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String flowerId;
  final String flowerName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.flowerId,
    required this.flowerName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      flowerId: map['flowerId'] ?? '',
      flowerName: map['flowerName'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flowerId': flowerId,
      'flowerName': flowerName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class FlowerOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // 'Pending', 'Preparing', 'Out for Delivery', 'Delivered'
  final DateTime createdAt;

  FlowerOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory FlowerOrder.fromFirestore(Map<String, dynamic> data, String docId) {
    var rawItems = data['items'] as List<dynamic>? ?? [];
    List<OrderItem> orderItems = rawItems
        .map((item) => OrderItem.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    return FlowerOrder(
      id: docId,
      customerName: data['customerName'] ?? 'Guest Customer',
      customerPhone: data['customerPhone'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      items: orderItems,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'items': items.map((i) => i.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

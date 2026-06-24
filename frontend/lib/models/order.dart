import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final String mealId;
  final String cookId;
  final DateTime deliveryDate;
  final String status;
  final int tiffinsReturned;

  Order({
    required this.id,
    required this.userId,
    required this.mealId,
    required this.cookId,
    required this.deliveryDate,
    required this.status,
    required this.tiffinsReturned,
  });

  factory Order.fromMap(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      userId: data['userId'] ?? '',
      mealId: data['mealId'] ?? '',
      cookId: data['cookId'] ?? '',
      deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      tiffinsReturned: data['tiffinsReturned'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mealId': mealId,
      'cookId': cookId,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'status': status,
      'tiffinsReturned': tiffinsReturned,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

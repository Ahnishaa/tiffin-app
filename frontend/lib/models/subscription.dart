import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String id;
  final String userId;
  final String planType;
  final int mealsRemaining;
  final Map<String, bool> activeDays;
  final String deliveryBatch;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.planType,
    required this.mealsRemaining,
    required this.activeDays,
    required this.deliveryBatch,
    required this.createdAt,
  });

  factory Subscription.fromMap(String id, Map<String, dynamic> data) {
    return Subscription(
      id: id,
      userId: data['userId'] ?? '',
      planType: data['planType'] ?? '',
      mealsRemaining: data['mealsRemaining'] ?? 0,
      activeDays: Map<String, bool>.from(data['activeDays'] ?? {}),
      deliveryBatch: data['deliveryBatch'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'planType': planType,
      'mealsRemaining': mealsRemaining,
      'activeDays': activeDays,
      'deliveryBatch': deliveryBatch,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

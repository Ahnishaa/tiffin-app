import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final String description;
  final String dayOfWeek;
  final String cookId;
  final String? imageUrl;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.dayOfWeek,
    required this.cookId,
    this.imageUrl,
  });

  factory Meal.fromMap(String id, Map<String, dynamic> data) {
    return Meal(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      dayOfWeek: data['dayOfWeek'] ?? '',
      cookId: data['cookId'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dayOfWeek': dayOfWeek,
      'cookId': cookId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

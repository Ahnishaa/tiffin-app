import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/meal.dart';
import '../models/subscription.dart';
import '../models/order.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -- User Profile --
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // -- Meals --
  Stream<List<Meal>> getMeals() {
    return _db.collection('meals').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Meal.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addMeal(Meal meal) async {
    await _db.collection('meals').add(meal.toMap());
  }

  Future<void> updateMeal(Meal meal) async {
    await _db.collection('meals').doc(meal.id).update(meal.toMap());
  }

  Future<void> deleteMeal(String id) async {
    await _db.collection('meals').doc(id).delete();
  }

  // -- Subscriptions --
  Stream<Subscription?> getUserSubscription(String userId) {
    return _db
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return Subscription.fromMap(doc.id, doc.data());
      }
      return null;
    });
  }

  Future<String> createOrUpdateSubscription(Subscription sub) async {
    if (sub.id.isEmpty) {
      final docRef = await _db.collection('subscriptions').add(sub.toMap());
      return docRef.id;
    } else {
      await _db.collection('subscriptions').doc(sub.id).update(sub.toMap());
      return sub.id;
    }
  }

  Future<void> updateSubscriptionPreferences(
      String subId, Map<String, bool> activeDays, String deliveryBatch) async {
    await _db.collection('subscriptions').doc(subId).update({
      'activeDays': activeDays,
      'deliveryBatch': deliveryBatch,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // -- Orders --
  Stream<List<Order>> getOrdersForCook(String cookId) {
    return _db
        .collection('orders')
        .where('cookId', isEqualTo: cookId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromMap(doc.id, doc.data())).toList());
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> placeOrder(Order order) async {
    await _db.collection('orders').add(order.toMap());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status, 'updatedAt': FieldValue.serverTimestamp()});
  }
}

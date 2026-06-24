import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/subscription.dart';
import '../models/order.dart';
import '../services/database_service.dart';

class DataProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Meal> _meals = [];
  Subscription? _subscription;
  List<Order> _orders = [];

  List<Meal> get meals => _meals;
  Subscription? get subscription => _subscription;
  List<Order> get orders => _orders;

  void loadMeals() {
    _dbService.getMeals().listen((mealsList) {
      _meals = mealsList;
      notifyListeners();
    });
  }

  void loadUserSubscription(String userId) {
    _dbService.getUserSubscription(userId).listen((sub) {
      _subscription = sub;
      notifyListeners();
    });
  }

  void loadUserOrders(String userId) {
    _dbService.getUserOrders(userId).listen((ordersList) {
      _orders = ordersList;
      notifyListeners();
    });
  }

  void loadCookOrders(String cookId) {
    _dbService.getOrdersForCook(cookId).listen((ordersList) {
      _orders = ordersList;
      notifyListeners();
    });
  }

  Future<void> updateSubscriptionPreferences(
      String subId, Map<String, bool> activeDays, String deliveryBatch) async {
    await _dbService.updateSubscriptionPreferences(subId, activeDays, deliveryBatch);
  }

  Future<String> createSubscription(Subscription sub) async {
    return await _dbService.createOrUpdateSubscription(sub);
  }

  Future<void> addMeal(Meal meal) async {
    await _dbService.addMeal(meal);
  }

  Future<void> updateMeal(Meal meal) async {
    await _dbService.updateMeal(meal);
  }

  Future<void> deleteMeal(String mealId) async {
    await _dbService.deleteMeal(mealId);
  }

  Future<void> placeOrder(Order order) async {
    await _dbService.placeOrder(order);
  }
}

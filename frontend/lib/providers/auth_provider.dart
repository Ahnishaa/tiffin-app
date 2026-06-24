import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService authService;

  Map<String, dynamic>? _userProfile;
  User? _firebaseUser;
  bool _isLoading = false;
  String? _error;

  StreamSubscription<DocumentSnapshot>? _profileSubscription;

  AuthProvider({required this.authService}) {
    // Listen to Firebase Auth state changes globally
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      _profileSubscription?.cancel();
      if (user != null) {
        // Initial fetch
        _userProfile = await authService.getCurrentUserProfile(user.uid);
        notifyListeners();
        
        // Listen to realtime updates
        _profileSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            _userProfile = snapshot.data();
            notifyListeners();
          }
        });
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  Map<String, dynamic>? get user => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;

  Future<void> checkAuthStatus() async {
    // Firebase handles this automatically via authStateChanges
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      await authService.login(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Authentication failed';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String fullName, String email, String password, {String role = 'CUSTOMER', String? phone}) async {
    _setLoading(true);
    _error = null;
    try {
      await authService.register(fullName, email, password, role, phone: phone);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Registration failed';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await authService.logout();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      _user = doc.exists ? UserModel.fromMap(doc.data()!) : null;
    } catch (_) {
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      _user = await _authService.signInWithEmail(email, password);
    } catch (e) { _error = e.toString(); }
    _isLoading = false; notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      _user = await _authService.signUpWithEmail(email, password, name);
    } catch (e) { _error = e.toString(); }
    _isLoading = false; notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      _user = await _authService.signInWithGoogle();
    } catch (e) { _error = e.toString(); }
    _isLoading = false; notifyListeners();
  }

  Future<void> signInAnonymously() async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      _user = await _authService.signInAnonymously();
    } catch (e) { _error = e.toString(); }
    _isLoading = false; notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}

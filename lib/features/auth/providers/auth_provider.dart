import 'package:flutter/cupertino.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<User?> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      User? user = await _authService.signInWithEmail(email, password);
      _user = user;
      _errorMessage = null;

      notifyListeners(); // Cập nhật UI
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signUpWithEmail(email, password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> signInWithGoogle() async {
    _setLoading(true);
    try {
      User? user = await _authService.signInWithGoogle();
      _user = user;
      _errorMessage = null;

      notifyListeners(); // Cập nhật UI
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Kiểm tra xem có user đã đăng nhập không
  Future<void> checkUserLoggedIn() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

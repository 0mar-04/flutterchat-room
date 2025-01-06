import 'package:flutter/material.dart';
import 'auth_service.dart';  // Ensure you have the correct import for your AuthService

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Sign up method that interacts with AuthService
  Future<String?> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Await the result from AuthService
    String? message = await _authService.signUp(email, password);

    // Update loading status
    _isLoading = false;
    notifyListeners();

    return message;
  }
}

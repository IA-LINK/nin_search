import 'package:flutter/material.dart';

class AppUser {
  const AppUser({required this.email});

  final String email;
}

class AuthService extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  // 🔐 REGISTER
  Future<String?> register(String email, String password) async {
    try {
      _user = AppUser(email: email);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 🔐 LOGIN
  Future<String?> login(String email, String password) async {
    try {
      _user = AppUser(email: email);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final dynamic _authService = _createAuthService();

  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  dynamic get authService => _authService;

  static dynamic _createAuthService() => null;
}

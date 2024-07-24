import 'package:bookstore/login.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  String _role = '';

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get role => _role;

  void login(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLogin: (username, role) {
            _isLoggedIn = true;
            _username = username;
            _role = role;
            notifyListeners();
          },
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }
}

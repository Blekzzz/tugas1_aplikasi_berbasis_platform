import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repo);

  final AuthRepository _repo;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  /// Mengembalikan true jika email & kata sandi cocok.
  bool login(String email, String password) {
    _isLoggedIn = _repo.login(email, password);
    notifyListeners();
    return _isLoggedIn;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

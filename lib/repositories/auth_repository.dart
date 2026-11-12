/// Autentikasi akun demo (autentikasi sungguhan dibahas di P8).
class AuthRepository {
  static const String demoEmail = 'admin@stokku.com';
  static const String demoPassword = 'admin123';

  bool login(String email, String password) {
    return email.trim().toLowerCase() == demoEmail && password == demoPassword;
  }
}

import 'package:hive/hive.dart';

class AuthRepository {
  final Box box;

  AuthRepository(this.box);

  static const _email = 'admin@test.com';
  static const _password = '123456';

  bool isLoggedIn() => box.get('loggedIn', defaultValue: false);

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate API

    if (email == _email && password == _password) {
      await box.put('loggedIn', true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await box.put('loggedIn', false);
  }
}

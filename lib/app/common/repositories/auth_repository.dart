import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final _secureStorage = FlutterSecureStorage();

  final _emailKey = "mover-email";
  final _passwordKey = "mover-password";

  Future<String?> getEmail() async {
    print("getEmail");
    return await _secureStorage.read(key: _emailKey);
  }

  Future<String?> getPassword() async {
    print("getPassword");
    return await _secureStorage.read(key: _passwordKey);
  }

  Future<bool> setAccount(String _email, String _password) async {
    try {
      // save email and password
      await _secureStorage.write(key: _emailKey, value: _emailKey);
      await _secureStorage.write(key: _passwordKey, value: _password);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/repositories/web3_repository.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:mover/app/common/utils/notification.dart';

class SignInProvider with ChangeNotifier {
  Web3Repository _web3Repository = Web3Repository();
  final AmplifyEndpoint _amplifyEndpoint = AmplifyEndpoint();
  final LocalAuthentication auth = LocalAuthentication();

  // for saving the user's email and password to the secure storage
  final _secureStorage = FlutterSecureStorage();
  final _emailKey = "email";
  final _passwordKey = "password";

  // for checking if the user has authenticated with fingerprint
  bool inProgress = false;

  String? email;

  String? get walletAddress => _web3Repository.currentAddress;

  Future<bool> hasSignInInfo() async {
    return await _secureStorage.containsKey(key: _emailKey) &&
        await _secureStorage.containsKey(key: _passwordKey);
  }

  loadCredential() async {
    await _web3Repository.loadCredential();
  }

  Future<SigninCredentials?> getSigninCredentials() async {
    final _email = await _secureStorage.read(key: _emailKey);
    final _password = await _secureStorage.read(key: _passwordKey);
    if ((null == _email || null == _password)) {
      // if the user has not signed in with email and password, then return null
      return null;
    }
    return SigninCredentials(username: _email, password: _password);
  }

  saveSigninCredentials(SigninCredentials signinCredentials) async {
    await _secureStorage.write(key: _emailKey, value: signinCredentials.email);
    await _secureStorage.write(
        key: _passwordKey, value: signinCredentials.password);
  }

  Future<bool> signIn(String username, String password) async {
    inProgress = true;
    if (await _amplifyEndpoint
        .signIn(SigninCredentials(username: username, password: password))) {
      inProgress = false;
      email = username;
      notifyListeners();
      return true;
    } else {
      print("error");
    }
    inProgress = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    await _amplifyEndpoint.signOut();
  }

  Future<String?> getCurrentUser() async {
    if (null == email) {
      return null;
    }
    email = (await _amplifyEndpoint.getCurrentUser()).username;
    return email;
  }

  Future<bool> signUp(String username, String password) async {
    inProgress = true;
    if (await _amplifyEndpoint.signUp(SignUpCredentials(
      username: username,
      password: password,
      email: username,
    ))) {
      inProgress = false;
      email = username;
      notifyListeners();
      return true;
    } else {
      print("error");
    }
    inProgress = false;
    notifyListeners();
    return false;
  }

  Future<bool> registerUser() async {
    inProgress = true;

    if (await _amplifyEndpoint.registerUser(
      _web3Repository.currentAddress!,
      email!,
      firebaseTokenID: Notifications.token,
    )) {
      inProgress = false;
      notifyListeners();
      return true;
    } else {
      print("error");
    }
    inProgress = false;
    notifyListeners();
    return false;
  }

  Future<void> resendSignUpCode() async {
    if (null == email) {
      return;
    }
    _amplifyEndpoint.resendSignUpCode(email!);
  }

  Future<bool> verifyCode(String code) async {
    inProgress = true;
    if (null == email) {
      return false;
    }
    if (await _amplifyEndpoint.verifyCode(email!, code)) {
      // if the code is verified, then sign in with the email and password
      inProgress = false;
      notifyListeners();
      return true;
    } else {
      print("error");
    }
    inProgress = false;
    notifyListeners();
    return false;
  }

  Future<bool> localAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (canAuthenticate) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate',
            options: const AuthenticationOptions(useErrorDialogs: false));
        if (didAuthenticate) {
          // success
          print("success");
          return true;
        }
      } on PlatformException catch (e) {
        print(e);
        if (e.code == auth_error.notAvailable) {
          // Add handling of no hardware here.
          print("no hardware");
        } else if (e.code == auth_error.notEnrolled) {
          // ...
          print("not enrolled");
        } else {
          // ...
          print("other");
        }
      }
    }
    return false;
  }
}

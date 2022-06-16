import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

// Generated in previous step
import 'package:mover/models/ModelProvider.dart';
import 'package:mover/amplifyconfiguration.dart';

class AmplifyEndpoint {
  static final AmplifyEndpoint _instance = AmplifyEndpoint._internal();
  factory AmplifyEndpoint() => _instance;
  AmplifyEndpoint._internal();

  init() async {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
  }

  Future<bool> signUp(SignUpCredentials credentials) async {
    try {
      Map<CognitoUserAttributeKey, String> userAttributes = {
        CognitoUserAttributeKey.email: credentials.email,
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: credentials.email,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      return res.isSignUpComplete;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> verifyCode(SignUpCredentials credentials) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: credentials.email, confirmationCode: '123456');
      return res.isSignUpComplete;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signin(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: credentials.email, password: credentials.password);
      return result.isSignedIn;
    } on AuthException catch (authError) {
      debugPrint('Could not login - ${authError.message}');
      return false;
    }
  }

  /// ====================================================
  /// User datastore Interface
  /// ====================================================
  registerUser(String walletID, {String firebaseTokenID = ""}) async {
    if (null != await getUser(walletID)) {
      // already registered
      print("User already registered");
      return;
    }

    await Amplify.DataStore.save(MoverUser(
      id: walletID,
      name: "",
      firebaseTokenID: firebaseTokenID,
      iconUrl: "",
      languagesAsISO639: [],
      email: "",
      walletID: walletID,
    ));
  }

  Future<MoverUser?> getUser(String walletID) async {
    try {
      List<MoverUser> Users = await Amplify.DataStore.query(
        MoverUser.classType,
        where: MoverUser.ID.eq(walletID),
      );
      print(Users);
      if (Users.isEmpty) {
        return null;
      }
      return Users.first;
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }
    return null;
  }

  updateUser(MoverUser user) async {
    MoverUser _user = (await Amplify.DataStore.query(MoverUser.classType,
        where: MoverUser.ID.eq(user.walletID)))[0];

    MoverUser _new = _user.copyWith(
      email: user.email,
      firebaseTokenID: user.firebaseTokenID,
      iconUrl: user.iconUrl,
      languagesAsISO639: user.languagesAsISO639,
      name: user.name,
    );

    await Amplify.DataStore.save(_new);
  }
}

abstract class AuthCredentials {
  final String email;
  final String password;

  AuthCredentials({required this.email, required this.password})
      : assert(email != null),
        assert(password != null);
}

class SigninCredentials extends AuthCredentials {
  SigninCredentials({required String username, required String password})
      : super(email: username, password: password);
}

class SignUpCredentials extends AuthCredentials {
  final String email;
  SignUpCredentials(
      {required String username, required String password, required this.email})
      : assert(email != null),
        super(email: username, password: password);
}

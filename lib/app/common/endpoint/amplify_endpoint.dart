import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

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

    await signOut();
  }

  Future<bool> signUp(SignUpCredentials credentials) async {
    Map<CognitoUserAttributeKey, String> userAttributes = {
      CognitoUserAttributeKey.email: credentials.email,
    };
    SignUpResult res = await Amplify.Auth.signUp(
        username: credentials.email,
        password: credentials.password,
        options: CognitoSignUpOptions(userAttributes: userAttributes));
    return res.isSignUpComplete;
  }

  Future<void> resendSignUpCode(String username) async {
    final result = await Amplify.Auth.resendSignUpCode(username: username);
  }

  Future<bool> verifyCode(String email, String code) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: code);
      return res.isSignUpComplete;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<AuthUser> getCurrentUser() async {
    final result = await Amplify.Auth.getCurrentUser();
    return result;
  }

  Future<bool> signIn(AuthCredentials credentials) async {
    final result = await Amplify.Auth.signIn(
        username: credentials.email, password: credentials.password);
    await Amplify.DataStore.start();
    return result.isSignedIn;
  }

  Future<void> signOut() async {
    final result = await Amplify.Auth.signOut();
  }

  Future<void> forceSync() async {
    //XXX: This is a hack to force the sync to happen.
    // await Amplify.DataStore.clear();
    await Amplify.DataStore.start();
  }

  /// ====================================================
  /// User datastore Interface
  /// ====================================================
  Future<bool> registerUser(String walletID, String email,
      {String firebaseTokenID = ""}) async {
    if (null != await getUser(walletID)) {
      // already registered
      print("User already registered");
      return false;
    }

    await Amplify.DataStore.save(MoverUser(
      id: walletID,
      nickname: "Anonymous",
      firebaseTokenID: firebaseTokenID,
      iconUrl:
          "https://amplify-movermvpfrontend-asset.s3.ap-northeast-1.amazonaws.com/assets/default-icon.png",
      languagesAsISO639: [
        "en",
      ],
      email: email,
      wallet: walletID,
    ));

    return true;
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

  Future<List<MoverUser>?> getAllUser() async {
    try {
      List<MoverUser> user = await Amplify.DataStore.query(
        MoverUser.classType,
      );
      print(user);
      return user;
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }
    return null;
  }

  updateUser(MoverUser user) async {
    MoverUser _user = (await Amplify.DataStore.query(MoverUser.classType,
        where: MoverUser.ID.eq(user.wallet)))[0];

    MoverUser _new = _user.copyWith(
      email: user.email,
      firebaseTokenID: user.firebaseTokenID,
      iconUrl: user.iconUrl,
      languagesAsISO639: user.languagesAsISO639,
      nickname: user.nickname,
    );

    await Amplify.DataStore.save(_new);
  }

  /// ====================================================
  /// EmploymentRequest datastore Interface
  /// ====================================================
  Future<bool> registerEmploymentRequest(String employeeWallet, int periodMonth,
      int dayPerMonth, double hourPerDay, Currency currency, int price) async {
    await Amplify.DataStore.save(EmploymentRequest(
      id: "$employeeWallet-${DateTime.now().millisecondsSinceEpoch}",
      employeeWallet: employeeWallet,
      periodMonth: periodMonth,
      dayPerMonth: dayPerMonth,
      hourPerDay: hourPerDay,
      currency: currency.toString().split('.').last,
      price: price,
    ));

    return true;
  }

  Future<bool> deleteEmploymentRequest(String id) async {
    final _results = await Amplify.DataStore.query(EmploymentRequest.classType,
        where: EmploymentRequest.ID.eq(id));

    if (_results.isEmpty) {
      return false;
    }
    await Amplify.DataStore.delete(_results.first);

    return true;
  }

  Future<List<EmploymentRequest>> getEmploymentRequestList(
      String employeeWallet) async {
    final _results = await Amplify.DataStore.query(EmploymentRequest.classType,
        where: EmploymentRequest.EMPLOYEEWALLET.eq(employeeWallet));

    return _results;
  }

  updateEmploymentRequest(EmploymentRequest employmentRequest) async {
    List<EmploymentRequest> _employmentRequestList =
        (await Amplify.DataStore.query(EmploymentRequest.classType,
            where: EmploymentRequest.ID.eq(employmentRequest.id)));

    if (_employmentRequestList.isEmpty) {
      print("Could not find employment request");
      return;
    }
    EmploymentRequest _employmentRequest = _employmentRequestList.first;

    EmploymentRequest _new = _employmentRequest.copyWith(
      employerWallet: employmentRequest.employerWallet,
      start: employmentRequest.start,
      end: employmentRequest.end,
      currency: employmentRequest.currency,
      lockMonth: employmentRequest.lockMonth,
      vestingMonth: employmentRequest.vestingMonth,
      agreementId: employmentRequest.agreementId,
      extended: employmentRequest.extended,
      progressStatus: employmentRequest.progressStatus,
    );

    await Amplify.DataStore.save(_new);
  }

  updateTaskStatus(String id, String taskStatusJson) async {
    List<EmploymentRequest> _employmentRequestList =
        (await Amplify.DataStore.query(EmploymentRequest.classType,
            where: EmploymentRequest.ID.eq(id)));

    if (_employmentRequestList.isEmpty) {
      print("Could not find employment request");
      return;
    }
    EmploymentRequest _employmentRequest = _employmentRequestList.first;

    EmploymentRequest _new = _employmentRequest.copyWith(
      progressStatus: taskStatusJson,
    );

    await Amplify.DataStore.save(_new);
  }
}

enum Currency {
  NEW,
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

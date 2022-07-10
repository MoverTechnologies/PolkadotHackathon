import 'package:flutter/widgets.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/models/MoverUser.dart';

class UserProvider with ChangeNotifier {
  MoverUser? _user;

  MoverUser? get user => _user;

  setUser(String walletID) async {
    print("setUser");
    while (null == _user) {
      _user = await AmplifyEndpoint().getUser(walletID);
      await Future.delayed(Duration(seconds: 1));
      print("setUser: $_user");
    }
    notifyListeners();
  }
}

import 'package:flutter/widgets.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/models/MoverUser.dart';

class UserProvider with ChangeNotifier {
  MoverUser? _user;

  MoverUser? get user => _user;

  setUser(String walletID) async {
    _user = await AmplifyEndpoint().getUser(walletID);
    notifyListeners();
  }
}

import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

// Generated in previous step
import 'package:mover/models/ModelProvider.dart';
import 'package:mover/amplifyconfiguration.dart';

class DataStoreRepository {
  static final DataStoreRepository _instance = DataStoreRepository._internal();
  factory DataStoreRepository() => _instance;
  DataStoreRepository._internal();

  init() async {
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
  }

  test() async {
    final item = User(
      id: '1',
      nickname: 'John',
      email: '',
      discordId: '',
      walletId: '',
    );
    await Amplify.DataStore.save(item);

    try {
      List<User> Users = await Amplify.DataStore.query(User.classType);
      print(Users);
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }
  }
}

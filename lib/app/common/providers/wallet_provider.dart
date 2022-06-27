import 'package:flutter/material.dart';
import 'package:mover/app/common/repositories/web3_repository.dart';

class WalletProvider extends ChangeNotifier {
  final Web3Repository _web3Repository = Web3Repository();

  get chainID => _web3Repository.chain.chainID;

  bool get isConnected => _web3Repository.isConnected;

  /// connected : wallet Address(H160)
  /// disconnected : null
  String? get currentAddress => _web3Repository.currentAddress;

  /// for progress indicator
  bool inProgress = false;
  double progressPercent = 0;
  String progressStatus = "";

  Future<void> init() async {
    await _web3Repository.init();
    notifyListeners();
  }

  setCredential(String _secret) async {
    await _web3Repository.setCredential(_secret);
    notifyListeners();
  }

  Future<bool> contract() async {
    final _stream = await _web3Repository.contractCall();
    if (null == _stream) {
      inProgress = false;
      progressStatus = "failure mint contract call";
      notifyListeners();
      return false;
    }

    _stream.stream.listen((_) {
      print("_stream.listen");
    }, onDone: () async {
      print("_stream.listen onDone");

      inProgress = false;
      progressStatus = "success mint contract call";
      notifyListeners();
    }, onError: (e) {
      print("_stream.listen onError");
      inProgress = false;
      progressStatus = "failure mint contract call";
      notifyListeners();
    });

    return true;
  }

  Future<bool> mint(String employee, String id) async {
    print("mint: $id $currentAddress => $employee");
    // final _stream = await _web3Repository.contractCall();
    // if (null == _stream) {
    //   inProgress = false;
    //   progressStatus = "failure mint contract call";
    //   notifyListeners();
    //   return false;
    // }

    // _stream.stream.listen((_) {
    //   print("_stream.listen");
    // }, onDone: () async {
    //   print("_stream.listen onDone");

    //   inProgress = false;
    //   progressStatus = "success mint contract call";
    //   notifyListeners();
    // }, onError: (e) {
    //   print("_stream.listen onError");
    //   inProgress = false;
    //   progressStatus = "failure mint contract call";
    //   notifyListeners();
    // });

    return true;
  }

  Future<bool> addReview(String employee, String id, String review) async {
    print("addReview: $id $currentAddress => $employee $review");
    // final _stream = await _web3Repository.contractCall();
    // if (null == _stream) {
    //   inProgress = false;
    //   progressStatus = "failure mint contract call";
    //   notifyListeners();
    //   return false;
    // }

    // _stream.stream.listen((_) {
    //   print("_stream.listen");
    // }, onDone: () async {
    //   print("_stream.listen onDone");

    //   inProgress = false;
    //   progressStatus = "success mint contract call";
    //   notifyListeners();
    // }, onError: (e) {
    //   print("_stream.listen onError");
    //   inProgress = false;
    //   progressStatus = "failure mint contract call";
    //   notifyListeners();
    // });

    return true;
  }
}

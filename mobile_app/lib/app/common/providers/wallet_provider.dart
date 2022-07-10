import 'package:flutter/material.dart';
import 'package:mover/abi/AgreementContract.g.dart';
import 'package:mover/app/common/repositories/web3_repository.dart';
import 'package:web3dart/crypto.dart';

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

  Future<String?> createAgreeement(
      String employee, String daoName, int amount, DateTimeRange _range) async {
    print("createAgreeement: $daoName $currentAddress => $employee");
    inProgress = true;
    notifyListeners();
    if (false == await _web3Repository.approve(amount)) {
      // approve failed
      return null;
    }

    final agreementId = await _web3Repository.createAgreeement(
        employee, daoName, amount, _range);
    if (null == agreementId) {
      inProgress = false;
      progressStatus = "failure mint contract call";
      notifyListeners();
      return null;
    }

    inProgress = false;
    notifyListeners();
    return agreementId;
  }

  Future<bool> completeAgreement(String agreementId, String review) async {
    print("completeAgreement: $agreementId $currentAddress => $review");
    inProgress = true;
    notifyListeners();
    final _completeAgreement =
        await _web3Repository.completeAgreement(agreementId, review);
    if (null == _completeAgreement) {
      inProgress = false;
      progressStatus = "failure mint contract call";
      notifyListeners();
      return false;
    }

    print(_completeAgreement);
    inProgress = false;
    notifyListeners();

    return true;
  }
}

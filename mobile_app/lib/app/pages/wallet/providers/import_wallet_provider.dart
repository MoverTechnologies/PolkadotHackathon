import 'package:flutter/material.dart';
import 'package:mover/app/common/repositories/web3_repository.dart';

class ImportWalletProvider with ChangeNotifier {
  bool _isWalletInitialized = false;

  final Web3Repository _web3Repository = Web3Repository();

  bool get isWalletInitialized => _isWalletInitialized;

  Future<bool> importWallet(String _secretkey) async {
    final _isSuccess = await _web3Repository.setCredential(_secretkey);
    if (_isSuccess) {
      _isWalletInitialized = true;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}

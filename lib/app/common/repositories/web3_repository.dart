import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:mover/app/common/config/config.dart';
import 'package:mover/app/common/models/chain_model.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

/// abi of the contract

/// dapps
class Web3Repository {
  /// web3 singleton instance
  static Web3Repository? _instance;

  factory Web3Repository() {
    if (_instance == null) {
      _instance = new Web3Repository._();
    }

    return _instance!;
  }

  Web3Repository._();

  // chain model
  ChainModel chain = Config.chain;

  // credentials
  Credentials? _credential;

  // secure storage key for private key
  final _privateKeyAsMapKey = "privateKey";

  // for saving private key
  final _secureStorage = FlutterSecureStorage();

  bool hasPrivateKey = false;

  /// chain infomations
  bool get isConnected => (null != _credential) ? true : false;

  /// current wallet address
  String? currentAddress;

  Future<void> init() async {
    print("init");
    // await _secureStorage.deleteAll();
    hasPrivateKey = await _secureStorage.containsKey(key: _privateKeyAsMapKey);
    print("hasPrivateKey: $hasPrivateKey");
  }

  Future<void> loadCredential() async {
    print("loadCredential");

    String? _privateKey = await _secureStorage.read(key: _privateKeyAsMapKey);
    if (null != _privateKey) {
      // already have private key
      await setCredential(_privateKey);
    }
  }

  Future<bool> setCredential(String _secret) async {
    if (64 != _secret.length) {
      return false;
    }

    try {
      _credential = EthPrivateKey.fromHex(_secret);
      currentAddress = (await _credential!.extractAddress()).hexEip55;
      print(currentAddress);

      // save private key
      print("save private key");
      await _secureStorage.write(key: _privateKeyAsMapKey, value: _secret);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  deleteCredential() async {
    await _secureStorage.delete(key: _privateKeyAsMapKey);
  }

  Future<bool> startConnect(BuildContext context) async {
    print("create session...");
    return true;
  }

  String _getButtonText() {
    if (null == _credential) {
      return "Connect";
    }
    return currentAddress!;
  }

  Future<bool> signMessage(String _message) async {
    print("signMessage");
    final message = await _credential!.signPersonalMessage(
      hexToBytes(_message),
      chainId: chain.chainID,
    );

    print(message);

    return true;
  }

  // ============================================================
  // Any contract
  // ============================================================
  Future<StreamController<TransactionReceipt?>?> contractCall() async {
    if (null == _credential) {
      // not connected
      return null;
    }

    final _stream = StreamController<TransactionReceipt?>();
    Future.delayed(Duration(seconds: 5)).then((value) {
      _stream.add(_transactionReceiptTest);
      _stream.close();
    });

    return _stream;
  }

  Future<BigInt?> balanceOf() async {
    if (null == _credential) {
      // not connected
      return null;
    }

    return BigInt.from(10);
  }
  // ============================================================

  // ============================================================
  // Proved contract
  // ============================================================
  Future<StreamController<TransactionReceipt?>?> mint(String id) async {
    // TODO: implement mint
    // if (null == _credential) {
    //   // not connected
    //   return null;
    // }

    // final _sender = EthereumAddress.fromHex(currentAddress!);
    // print("addr $currentAddress");

    // final client = Web3Client(chain.rpcUrl, Client());
    // final _transaction = Transaction(
    //   from: _sender,
    //   value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
    //   nonce: await client.getTransactionCount(_sender,
    //       atBlock: BlockNum.pending()),
    //   maxGas: 5000000,

    //   gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
    //   // EIP-1559
    //   maxFeePerGas:
    //       EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
    //   maxPriorityFeePerGas:
    //       EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    // );

    // print("signing...");

    // Mynft _myNft = Mynft(
    //     // your contract argument
    //     address: EthereumAddress.fromHex(ContractConfig.myNftContract.address),
    //     client: client,
    //     chainId: chain.chainID);

    // final tx = await _myNft.mint(
    //   _sender,
    //   credentials: _credential!,
    //   transaction: _transaction,
    // );

    // print("tx: ${tx}");

    // final _stream = StreamController<TransactionReceipt?>();
    // _waitTransaction(client, tx).then((value) {
    //   _stream.add(value);
    //   _stream.close();
    //   client.dispose();
    // }, onError: (e) {
    //   _stream.addError(e);
    //   _stream.close();
    //   client.dispose();
    // });

    // return _stream;
  }

  Future<StreamController<TransactionReceipt?>?> addReview(
      String id, String review) async {
    // TODO: implement addReview
    // if (null == _credential) {
    //   // not connected
    //   return null;
    // }

    // final _sender = EthereumAddress.fromHex(currentAddress!);
    // print("addr $currentAddress");

    // final client = Web3Client(chain.rpcUrl, Client());
    // final _transaction = Transaction(
    //   from: _sender,
    //   value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
    //   nonce: await client.getTransactionCount(_sender,
    //       atBlock: BlockNum.pending()),
    //   maxGas: 5000000,

    //   gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
    //   // EIP-1559
    //   maxFeePerGas:
    //       EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
    //   maxPriorityFeePerGas:
    //       EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    // );

    // print("signing...");

    // Mynft _myNft = Mynft(
    //     // your contract argument
    //     address: EthereumAddress.fromHex(ContractConfig.myNftContract.address),
    //     client: client,
    //     chainId: chain.chainID);

    // final tx = await _myNft.mint(
    //   _sender,
    //   credentials: _credential!,
    //   transaction: _transaction,
    // );

    // print("tx: ${tx}");

    // final _stream = StreamController<TransactionReceipt?>();
    // _waitTransaction(client, tx).then((value) {
    //   _stream.add(value);
    //   _stream.close();
    //   client.dispose();
    // }, onError: (e) {
    //   _stream.addError(e);
    //   _stream.close();
    //   client.dispose();
    // });

    // return _stream;
  }

  // ============================================================

  // wait transaction to be confirmed
  Future<TransactionReceipt?> _waitTransaction(
      Web3Client _client, String _tx) async {
    int _cnt = 0;
    const int cntMax = 600; // 10min
    TransactionReceipt? _receipt;

    while (true) {
      _receipt = await _client.getTransactionReceipt(_tx);
      if (null != _receipt) {
        print("receipt: ${_receipt}");
        break;
      }
      if (_cnt++ >= cntMax) {
        break;
      }
      await Future.delayed(Duration(seconds: 1));
      print("retry: ${_cnt}");
    }

    return _receipt;
  }

  /// TransactionReceipt test data
  final _transactionReceiptTest = TransactionReceipt(
    blockHash: Uint8List(
        0x0000000000000000000000000000000000000000000000000000000000000000),
    contractAddress:
        EthereumAddress.fromHex("0x0000000000000000000000000000000000000000"),
    cumulativeGasUsed: BigInt.from(0),
    from: EthereumAddress.fromHex("0x0000000000000000000000000000000000000000"),
    gasUsed: BigInt.from(0),
    logs: [],
    transactionHash: Uint8List(
        0x0000000000000000000000000000000000000000000000000000000000000000),
    transactionIndex: 1234,
  );
}

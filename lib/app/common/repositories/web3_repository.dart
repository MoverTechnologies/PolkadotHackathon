import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:mover/abi/AgreementContract.g.dart';
import 'package:mover/abi/PoM.g.dart';
import 'package:mover/abi/Token.g.dart';
import 'package:mover/abi/Vesting.g.dart';
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

  // TODO: add contract caller
  // ============================================================
  // PoM contract
  // ============================================================
  Future<dynamic> getProofDetails() async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    PoM _pom = PoM(
        // your contract argument
        address: EthereumAddress.fromHex(Config.pomContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _pom.getProofDetail(BigInt.from(4));

    client.dispose();

    print("fetching proof details...");

    return tx;
  }

  Future<List<BigInt>?> getAllTokenIds(String moderatorAddress) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    PoM _pom = PoM(
        // your contract argument
        address: EthereumAddress.fromHex(Config.pomContract.address),
        client: client,
        chainId: chain.chainID);

    print("fetching proof ids...");
    final tx = await _pom.getAllTokenIds(EthereumAddress.fromHex(moderatorAddress));

    client.dispose();

    return tx;
  }

  Future<BigInt?> tokenID(String proofId) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    PoM _pom = PoM(
        // your contract argument
        address: EthereumAddress.fromHex(Config.pomContract.address),
        client: client,
        chainId: chain.chainID);

    print("fetching token id...");
    final tx = await _pom.tokenID(hexToBytes(proofId));

    client.dispose();

    return tx;
  }

  Future<StreamController<TransactionReceipt?>?> burnToken(String proofId) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: BlockNum.pending()),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("processing...");

    PoM _pom = PoM(
        // your contract argument
        address: EthereumAddress.fromHex(Config.pomContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _pom.burnToken(hexToBytes(proofId), credentials: _credential!, transaction: _transaction);

    print("tx: ${tx}");

    final _stream = StreamController<TransactionReceipt?>();
    _waitTransaction(client, tx).then((value) {
      _stream.add(value);
      _stream.close();
      client.dispose();
    }, onError: (e) {
      _stream.addError(e);
      _stream.close();
      client.dispose();
    });

    return _stream;
  }

  // ============================================================
  // Agreeement contract
  // ============================================================
  Future<String?> createAgreeement(String moderatorAddress, String daoName, int amount, DateTimeRange _range) async {
    String? _ret;
    if (null == _credential) {
      // not connected
      return null;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    BlockNum _blockNum = BlockNum.pending();
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: _blockNum),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("signing...");

    AgreementContract _agreement = AgreementContract(
        // your contract argument
        address: EthereumAddress.fromHex(Config.agreementContract.address),
        client: client,
        chainId: chain.chainID);

    BigInt? balance = await balanceOf();
    print("balance : $balance");
    final tx = await _agreement.createAgreement(
      EthereumAddress.fromHex(moderatorAddress),
      Uint8List.fromList(daoName.padLeft(22).codeUnits), // 22bytes of daoName
      BigInt.from(_range.start.millisecondsSinceEpoch / 1000), // start time (currentTime)
      BigInt.from(_range.end.millisecondsSinceEpoch / 1000), // end time (currentTime)
      EtherAmount.fromUnitAndValue(EtherUnit.ether, amount).getInWei, // reward amount
      BigInt.from(60), // vesting duration (60s after endTime has passed)
      credentials: _credential!,
      transaction: _transaction,
    );

    final _receipt = await _waitTransaction(client, tx);
    if (null == _receipt || null == _receipt.status || false == _receipt.status) {
      return null;
    }

    // event subscription
    final _list = await client.getLogs(FilterOptions.events(
      contract: _agreement.self,
      event: _agreement.self.event('CreateAgreement'),
    ));
    print("logs: ${_list}");
    if (_list.isEmpty) {
      return null;
    }
    _ret = _list.first.topics![2];
    print("agreeement id: $_ret");

    client.dispose();

    return _ret;
  }

  Future<UpdateAgreement?> updateAgreement(String agreementId, DateTimeRange _range, int amount) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: BlockNum.pending()),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("signing...");

    AgreementContract _agreement = AgreementContract(
        // your contract argument
        address: EthereumAddress.fromHex(Config.agreementContract.address),
        client: client,
        chainId: chain.chainID);

    UpdateAgreement? _ret;

    final tx = await _agreement.updateAgreement(
      hexToBytes(agreementId),
      BigInt.from((_range.start.millisecondsSinceEpoch / 1000).floor()), // start time
      BigInt.from((_range.end.millisecondsSinceEpoch / 1000).floor()), // end time
      EtherAmount.fromUnitAndValue(EtherUnit.ether, amount).getInWei, // reward amount
      credentials: _credential!,
      transaction: _transaction,
    );

    print("tx: ${tx}");

    final _receipt = await _waitTransaction(client, tx);
    if (null == _receipt || null == _receipt.status || false == _receipt.status) {
      return null;
    }

    client.dispose();

    return _ret;
  }

  Future<CompleteAgreement?> completeAgreement(String agreementId, String review) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: BlockNum.pending()),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("signing...");

    AgreementContract _agreement = AgreementContract(
        // your contract argument
        address: EthereumAddress.fromHex(Config.agreementContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _agreement.completeAgreement(
      hexToBytes(agreementId),
      review, // review
      credentials: _credential!,
      transaction: _transaction,
    );

    print("tx: ${tx}");

    CompleteAgreement? _ret;
    final _receipt = await _waitTransaction(client, tx);
    if (null == _receipt || null == _receipt.status || false == _receipt.status) {
      return null;
    }
    // event subscription
    final _list = await client.getLogs(FilterOptions.events(
      contract: _agreement.self,
      event: _agreement.self.event('CompleteAgreement'),
    ));
    print("logs: ${_list}");
    if (_list.isEmpty) {
      return null;
    }
    _ret = CompleteAgreement([hexToBytes(_list.first.topics![1])]);
    print(_ret);

    return _ret;
  }

  Future<List<Uint8List>?> getAgreementIds(String moderatorAddress) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    print("get agreement ids...");

    final client = Web3Client(chain.rpcUrl, Client());
    AgreementContract _agreement = AgreementContract(
        // your contract argument
        address: EthereumAddress.fromHex(Config.agreementContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _agreement.getAllIds(EthereumAddress.fromHex(moderatorAddress));

    client.dispose();
    return tx;
  }

  Future<dynamic> getAgreementDetails(String agreementId) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    AgreementContract _agreement = AgreementContract(
        // your contract argument
        address: EthereumAddress.fromHex(Config.agreementContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _agreement.getAgreementDetail(hexToBytes(agreementId));

    client.dispose();
    return tx;
  }

  Future<BigInt?> getTotalAgreements() async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    AgreementContract _agreement = AgreementContract(address: EthereumAddress.fromHex(Config.agreementContract.address), client: client, chainId: chain.chainID);

    print("get total agreement count...");

    final totalCount = await _agreement.getTotalAgreements();

    client.dispose();
    return totalCount;
  }

  // ============================================================
  // Vesting contract
  // ============================================================
  Future<ModInfoVesting?> getVestingInfoDetail(String agreementId) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    Vesting _vesting = Vesting(address: EthereumAddress.fromHex(Config.vestingContract.address), client: client, chainId: chain.chainID);

    print("get total agreement count...");

    final tx = await _vesting.modInfoVesting(hexToBytes(agreementId));

    client.dispose();
    return tx;
  }

  Future<StreamController<TransactionReceipt?>?> release(String agreementId) async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: BlockNum.pending()),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("signing...");

    Vesting _agreement = Vesting(
        // your contract argument
        address: EthereumAddress.fromHex(Config.vestingContract.address),
        client: client,
        chainId: chain.chainID);

    final tx = await _agreement.release(
      hexToBytes(agreementId),
      credentials: _credential!,
      transaction: _transaction,
    );

    print("tx: ${tx}");

    final _stream = StreamController<TransactionReceipt?>();
    _waitTransaction(client, tx).then((value) {
      _stream.add(value);
      _stream.close();
      client.dispose();
    }, onError: (e) {
      _stream.addError(e);
      _stream.close();
      client.dispose();
    });

    return _stream;
  }

  // ============================================================
  // Token contract
  // ============================================================
  Future<bool> approve(int amount) async {
    if (null == _credential) {
      // not connected
      return false;
    }
    final _sender = EthereumAddress.fromHex(currentAddress!);
    print("addr $currentAddress");

    final client = Web3Client(chain.rpcUrl, Client());
    final _transaction = Transaction(
      from: _sender,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(0)),
      nonce: await client.getTransactionCount(_sender, atBlock: BlockNum.pending()),
      maxGas: 1000000,

      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(200)),
      // EIP-1559
      maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(70)),
      maxPriorityFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(30)),
    );

    print("approving... ${EtherAmount.fromUnitAndValue(EtherUnit.ether, amount).getInWei}");

    Token _token = Token(
        // your contract argument
        address: EthereumAddress.fromHex(Config.tokenContract.address),
        client: client,
        chainId: chain.chainID);
    final tx = await _token.approve(
      EthereumAddress.fromHex(Config.vestingContract.address),
      EtherAmount.fromUnitAndValue(EtherUnit.ether, amount).getInWei,
      credentials: _credential!,
      transaction: _transaction,
    );

    print("tx: ${tx}");

    final _receipt = await _waitTransaction(client, tx);
    if (null == _receipt || null == _receipt.status || false == _receipt.status) {
      client.dispose();
      return false;
    }
    client.dispose();

    return true;
  }

  Future<BigInt?> balanceOf() async {
    if (null == _credential) {
      // not connected
      return null;
    }
    final client = Web3Client(chain.rpcUrl, Client());
    Token _token = Token(address: EthereumAddress.fromHex(Config.tokenContract.address), client: client, chainId: chain.chainID);

    print("get my balance...");

    final balance = await _token.balanceOf(
      EthereumAddress.fromHex(currentAddress!),
    );

    client.dispose();
    return balance;
  }
  // ============================================================

  // wait transaction to be confirmed
  Future<TransactionReceipt?> _waitTransaction(Web3Client _client, String _tx) async {
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
    blockHash: Uint8List(0x0000000000000000000000000000000000000000000000000000000000000000),
    contractAddress: EthereumAddress.fromHex("0x0000000000000000000000000000000000000000"),
    cumulativeGasUsed: BigInt.from(0),
    from: EthereumAddress.fromHex("0x0000000000000000000000000000000000000000"),
    gasUsed: BigInt.from(0),
    logs: [],
    transactionHash: Uint8List(0x0000000000000000000000000000000000000000000000000000000000000000),
    transactionIndex: 1234,
  );
}

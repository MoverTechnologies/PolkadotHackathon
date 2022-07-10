// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"proofId","type":"bytes32"},{"indexed":true,"internalType":"address","name":"founder","type":"address"}],"name":"AddVestingInfo","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"proofId","type":"bytes32"},{"indexed":true,"internalType":"address","name":"mod","type":"address"},{"indexed":true,"internalType":"uint256","name":"reward","type":"uint256"}],"name":"Released","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"proofId","type":"bytes32"},{"indexed":true,"internalType":"address","name":"founder","type":"address"}],"name":"Revoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"proofId","type":"bytes32"}],"name":"UpdateVestingInfo","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_proofId","type":"bytes32"},{"internalType":"address","name":"_founderAddress","type":"address"},{"internalType":"address","name":"_modAddress","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"uint32","name":"_jobEndTime","type":"uint32"},{"internalType":"uint256","name":"_duration","type":"uint256"}],"name":"addVestingInfo","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"depositedToken","outputs":[{"internalType":"contract IERC20Upgradeable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"contract IERC20Upgradeable","name":"_depositedToken","type":"address"}],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"name":"modInfoVesting","outputs":[{"internalType":"address","name":"founderAddress","type":"address"},{"internalType":"address","name":"modAddress","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"released","type":"uint256"},{"internalType":"uint32","name":"jobEndTime","type":"uint32"},{"internalType":"uint256","name":"duration","type":"uint256"},{"internalType":"bool","name":"completed","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_proofId","type":"bytes32"}],"name":"release","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_proofId","type":"bytes32"}],"name":"releaseAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_proofId","type":"bytes32"}],"name":"revoke","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_contractAddr","type":"address"}],"name":"setAgreementContractAddress","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_depositedToken","type":"address"}],"name":"setDepoistedToken","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_proofId","type":"bytes32"},{"internalType":"uint256","name":"_amount","type":"uint256"},{"internalType":"uint32","name":"_jobEndTime","type":"uint32"}],"name":"updateVestingInfo","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'Vesting');

class Vesting extends _i1.GeneratedContract {
  Vesting(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> addVestingInfo(
      _i2.Uint8List _proofId,
      _i1.EthereumAddress _founderAddress,
      _i1.EthereumAddress _modAddress,
      BigInt _amount,
      BigInt _jobEndTime,
      BigInt _duration,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '90156c58'));
    final params = [
      _proofId,
      _founderAddress,
      _modAddress,
      _amount,
      _jobEndTime,
      _duration
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> depositedToken({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'dad9b086'));
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> initialize(_i1.EthereumAddress _depositedToken,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'c4d66de8'));
    final params = [_depositedToken];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<ModInfoVesting> modInfoVesting(_i2.Uint8List $param7,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '1e5d7be5'));
    final params = [$param7];
    final response = await read(function, params, atBlock);
    return ModInfoVesting(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> owner({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '8da5cb5b'));
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> release(_i2.Uint8List _proofId,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '67d42a8b'));
    final params = [_proofId];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> releaseAmount(_i2.Uint8List _proofId,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '663b61b2'));
    final params = [_proofId];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> renounceOwnership(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '715018a6'));
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> revoke(_i2.Uint8List _proofId,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'b75c7dc6'));
    final params = [_proofId];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setAgreementContractAddress(_i1.EthereumAddress _contractAddr,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '0a0442a8'));
    final params = [_contractAddr];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setDepoistedToken(_i1.EthereumAddress _depositedToken,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'bace6865'));
    final params = [_depositedToken];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferOwnership(_i1.EthereumAddress newOwner,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, 'f2fde38b'));
    final params = [newOwner];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> updateVestingInfo(
      _i2.Uint8List _proofId, BigInt _amount, BigInt _jobEndTime,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'f22e88b6'));
    final params = [_proofId, _amount, _jobEndTime];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all AddVestingInfo events emitted by this contract.
  Stream<AddVestingInfo> addVestingInfoEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('AddVestingInfo');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return AddVestingInfo(decoded);
    });
  }

  /// Returns a live stream of all OwnershipTransferred events emitted by this contract.
  Stream<OwnershipTransferred> ownershipTransferredEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('OwnershipTransferred');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return OwnershipTransferred(decoded);
    });
  }

  /// Returns a live stream of all Released events emitted by this contract.
  Stream<Released> releasedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('Released');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return Released(decoded);
    });
  }

  /// Returns a live stream of all Revoked events emitted by this contract.
  Stream<Revoked> revokedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('Revoked');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return Revoked(decoded);
    });
  }

  /// Returns a live stream of all UpdateVestingInfo events emitted by this contract.
  Stream<UpdateVestingInfo> updateVestingInfoEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('UpdateVestingInfo');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return UpdateVestingInfo(decoded);
    });
  }
}

class ModInfoVesting {
  ModInfoVesting(List<dynamic> response)
      : founderAddress = (response[0] as _i1.EthereumAddress),
        modAddress = (response[1] as _i1.EthereumAddress),
        amount = (response[2] as BigInt),
        released = (response[3] as BigInt),
        jobEndTime = (response[4] as BigInt),
        duration = (response[5] as BigInt),
        completed = (response[6] as bool);

  final _i1.EthereumAddress founderAddress;

  final _i1.EthereumAddress modAddress;

  final BigInt amount;

  final BigInt released;

  final BigInt jobEndTime;

  final BigInt duration;

  final bool completed;
}

class AddVestingInfo {
  AddVestingInfo(List<dynamic> response)
      : proofId = (response[0] as _i2.Uint8List),
        founder = (response[1] as _i1.EthereumAddress);

  final _i2.Uint8List proofId;

  final _i1.EthereumAddress founder;
}

class OwnershipTransferred {
  OwnershipTransferred(List<dynamic> response)
      : previousOwner = (response[0] as _i1.EthereumAddress),
        newOwner = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress previousOwner;

  final _i1.EthereumAddress newOwner;
}

class Released {
  Released(List<dynamic> response)
      : proofId = (response[0] as _i2.Uint8List),
        mod = (response[1] as _i1.EthereumAddress),
        reward = (response[2] as BigInt);

  final _i2.Uint8List proofId;

  final _i1.EthereumAddress mod;

  final BigInt reward;
}

class Revoked {
  Revoked(List<dynamic> response)
      : proofId = (response[0] as _i2.Uint8List),
        founder = (response[1] as _i1.EthereumAddress);

  final _i2.Uint8List proofId;

  final _i1.EthereumAddress founder;
}

class UpdateVestingInfo {
  UpdateVestingInfo(List<dynamic> response)
      : proofId = (response[0] as _i2.Uint8List);

  final _i2.Uint8List proofId;
}

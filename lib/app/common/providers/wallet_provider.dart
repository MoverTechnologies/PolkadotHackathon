import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mover/app/common/config/config.dart';
import 'package:mover/app/common/utils/ethereum_transaction_tester.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/web3dart.dart';

import '../models/contract_model.dart';

class WalletProvider extends ChangeNotifier {
  /// connector for wallet connect
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'MOVER',
      description:
          'MOVER is a decentralized statistics platform for the Astar blockchain.',
      //TODO url: 'https://astar-stats.org/',
      //TODO icons: ['http://astar-stats.org/splash/img/dark-1x.png'],
    ),
  );

  /// for Astar Network
  final int _chainId = 592;

  /// progress of connecting wallet
  bool inProgress = false;

  /// session for wallet
  SessionStatus? session;

  /// connected wallet ID
  String? get connectedWalletID => isConnected ? session!.accounts.first : null;

  /// connected wallet ID
  bool get isConnected => (null != session);

  /// is correct chain id
  bool get isCorrectChain => (_chainId == session!.chainId);

  String get buttonText => _getButtonText();

  Future<bool> startConnect(BuildContext context) async {
    print("create session...");
    inProgress = true;
    notifyListeners();

    if (connector.connected) {
      // already connected
      connector.killSession();
      connector.close(forceClose: true);
    }

    session = await connector.createSession(
      chainId: _chainId,
      onDisplayUri: (uri) async {
        print(uri);
        if ((Platform.isIOS) || (Platform.isAndroid)) {
          // mobile App
          // connect by deep link
          await launchUrl(Uri.parse(uri));
        } else {
          // desktop App or web
          // connect by QR code
          await _showQRcodeDialog(context, uri);
        }
      },
    );

    if ((Platform.isIOS) || (Platform.isAndroid)) {
      // mobile App
      // finalize for deep link

    } else {
      // desktop App or web
      // finalize for QR code
      Navigator.pop(context);
    }
    print("done");
    inProgress = false;
    notifyListeners();
    print("connected : ${session!.accounts.first}(${session!.chainId})");

    if (_chainId != session!.chainId) {
      throw Exception('Invalid chain id');
    }

    return true;
  }

  Future<bool> contract_call(String _func, ContractModel _contract) async {
    final client = Web3Client(Config.chain.rpcUrl, Client());
    final EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(connector, chainId: _chainId);

    if (null == connectedWalletID) {
      return false;
    }
    final sender = EthereumAddress.fromHex(connectedWalletID!);
    final contractAddress = EthereumAddress.fromHex(_contract.address);
    final credentials = WalletConnectEthereumCredentials(provider: provider);
    String abiCode = await rootBundle.loadString(_contract.abiPath);
    final contractAbi = ContractAbi.fromJson(abiCode, _func);
    final contract = DeployedContract(contractAbi, contractAddress);

    //TODO: check balance
    final balance = await client.getBalance(sender);
    print("balance : $balance");

    //TODO: check gas price
    final gasPrice = await client.getGasPrice();
    final estimateGasPrice = await client.estimateGas(
      sender: sender,
      to: contractAddress,
      data: contract.function(_func).encodeCall([
        sender, contractAddress,
        // tokenId, Uint8List.fromList([])
      ]),
      gasPrice: gasPrice,
      amountOfGas: gasPrice.getInWei,
      value: EtherAmount.inWei(BigInt.from(0)),
    );

    final tx = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function(_func),
        gasPrice: EtherAmount.inWei(await client.estimateGas()),
        parameters: [sender],
        from: sender,
        nonce: await client.getTransactionCount(sender,
            atBlock: BlockNum.pending()),
      ),
    );

    print("tx : $tx");

    return true;
  }

  Future<void> _showQRcodeDialog(BuildContext context, String uri) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(
            title: Text('Wallet Connect'),
            children: [
              Container(
                  width: 200,
                  height: 200,
                  child: QrImage(
                    data: uri,
                    version: QrVersions.auto,
                    size: 200.0,
                  )),
              SimpleDialogOption(
                child: Text('calcel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  String _getButtonText() {
    if (null == session) {
      return "Connect";
    }
    if (_chainId != session!.chainId) {
      // invalid chain ID
      return "invalid chain(${session!.chainId})";
    }
    if (session!.accounts.isEmpty) {
      // not connected
      return "Connect";
    }
    return session!.accounts.first;
  }
}
